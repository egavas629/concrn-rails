class Report < ActiveRecord::Base
  belongs_to :responder
  has_one :dispatch

  def self.pending
    joins("left join dispatches d on d.report_id = reports.id").where("d.id is null").order("created_at desc")
  end

  def self.dispatched
    joins(:dispatch).order("created_at desc")
  end

  def responder_synopsis
    <<-SMS
    CRISIS REPORT:
    #{location}
    #{name}
    #{phone}
    SMS
  end


  def reporter_synopsis
    <<-SMS
    CRISIS RESPONSE:
    #{responder.name} is on the way.
    #{responder.phone}
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

  def location
    '265 Dolores Street, San Francisco 94043'
  end

  def dispatched?
    dispatch.present?
  end

  def status
    if dispatch.none?
      "unassigned"
    elsif dispatch.status == "pending"
      "dispatch_pending"
    elsif dispatch.status == "accepted"
      "dispatch_accepted"
    elsif dispatch.status == "completed"
      "dispatch_completed"
    end
  end
end
