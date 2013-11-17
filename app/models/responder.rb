class Responder < User
  default_scope -> { where(role: 'responder') }
  has_many :reports
  validates_presence_of :phone

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
