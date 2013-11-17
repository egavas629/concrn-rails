class Responder < User
  default_scope -> { where(role: 'responder') }
  has_many :reports
  validates_presence_of :phone

  def self.available
    find_by_sql(%Q{
      SELECT r.*, count(distinct d.id) as ad_count, count(distinct dr.id) as dr_count FROM users r 
        LEFT JOIN dispatches d on d.responder_id=r.id
        LEFT JOIN dispatches dr on dr.responder_id=r.id AND dr.status!='pending'
      WHERE r.role = 'responder'
      GROUP BY r.id
      HAVING count(distinct d.id) = count(distinct dr.id)
    })
  end

  def phone=(new_phone)
    write_attribute :phone, NumberSanitizer.sanitize(new_phone)
  end

  def accept_dispatch
    latest_dispatch.accept!
  end

  def dispatch_to(report)
    Dispatch.create!(report: report, responder: self)
  end

  private

  def latest_dispatch
    Dispatch.where(responder_id: id).latest
  end
end
