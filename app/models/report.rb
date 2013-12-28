class Report < ActiveRecord::Base
  has_many :dispatches
  has_many :logs
  # validates :state, within: ['unassigned', 'assigned', 'deleted']
  # after_commit :tell_jacob

  def tell_jacob
    Message.send responder_synopsis, to: '6502481396'
  end

  def responder
    current_dispatch.responder if dispatched?
  end

  def self.unassigned
    find_by_sql(<<-SQL)
      SELECT r.*, count(distinct d.id) as ad_count, count(distinct dr.id) as dr_count FROM reports r
        LEFT JOIN dispatches d on d.report_id=r.id
        LEFT JOIN dispatches dr on dr.report_id=r.id AND dr.status='rejected'
      WHERE r.status = 'pending'
      GROUP BY r.id
      HAVING count(distinct d.id) = count(distinct dr.id)
    SQL
  end

  def self.pending
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "pending"}).order("created_at desc")
  end

  def self.accepted
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "accepted"}).order("created_at desc")
  end

  def self.deleted
    where(status: "deleted")
  end

  def self.completed
    find_by_sql(%Q{
      SELECT r.* FROM reports r
        LEFT JOIN dispatches d on d.report_id=r.id
      WHERE r.status = 'completed' or d.status = 'completed'
      ORDER BY r.created_at desc
    })
  end

  def pending?
    current_dispatch && current_dispatch.pending?
  end

  def accepted?
    current_dispatch && current_dispatch.accepted?
  end

  def completed?
    current_dispatch && current_dispatch.completed?
  end

  def responder_synopsis
    <<-SMS
    CRISIS REPORT:
    Reporter:
    #{name}
    #{phone}
    Details:
    #{address}
    #{race}/#{gender}/#{age}
    #{setting}
    #{nature}
    SMS
  end

  def current_dispatch
    dispatches.last
  end

  def reporter_synopsis
    <<-SMS
    CRISIS RESPONSE:
    #{current_dispatch.responder.name} is on the way.
    #{current_dispatch.responder.phone}
    SMS
  end

  def freshness
    if created_at > 2.minutes.ago
      "fresh"
    elsif created_at > 4.minutes.ago
      "semi-fresh"
    elsif created_at > 9.minutes.ago
      "stale"
    else
      "old"
    end
  end

  def dispatch!(responder)
    dispatches.create!(responder: responder) if unassigned?
    # Only one responder, for now: only unassigned reports are eligible for dispatch.
  end

  def dispatched?
    dispatches.any?
  end

  def unassigned?
    !dispatched? || dispatches.all?(&:rejected?)
  end

  def status
    valid_dispatch = dispatches.not_rejected.latest
    valid_dispatch.present? ? valid_dispatch.status : "unassigned"
  end

  def deleted?
    attributes["status"] == "deleted"
  end

  def accept_feedback(opts={})
    logs.create! author: opts[:from], body: opts[:body]
  end
end
