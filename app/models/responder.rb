class Responder < User
  has_many :reports, through: :dispatches
  has_many :dispatches
  validates_presence_of :phone

  default_scope -> { where(role: 'responder') }
  scope :available, -> do
    joins(:dispatches).where(availability: 'available')
      .where.not('dispatches.status = (?) OR dispatches.status = (?)', 'pending', 'active')
  end

  def make_available!
    update_attributes(availability: 'available')
  end

  def phone=(new_phone)
    write_attribute :phone, NumberSanitizer.sanitize(new_phone)
  end

  def respond(body)
    give_feedback(body)

    return latest_dispatch.reject! if latest_dispatch.pending? && body.match(/no/i)
    return latest_dispatch.complete! if latest_dispatch.accepted? && body.match(/done/i)
    latest_dispatch.accept! unless latest_dispatch.accepted? || latest_dispatch.completed?
  end

  def completed_count
    dispatches.where(status: "completed").count
  end

  def rejected_count
    dispatches.where(status: "rejected").count
  end

  def available?
    availability == 'available'
  end

  def unavailable?
    availability == 'unavailable'
  end

  def status
    return "unassigned" if dispatches.none?

    last_dispatch = dispatches.order("created_at desc").first
    "last: #{last_dispatch.status}"
  end

  def set_password
    self.password              = 'password'
    self.password_confirmation = 'password'
  end

  private

  def latest_dispatch
    dispatches.latest
  end

  def give_feedback(body)
    latest_dispatch.report.accept_feedback(from: self, body: body)
  end
end
