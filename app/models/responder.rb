class Responder < User
  # RELATIONS #
  has_many :dispatches, dependent: :destroy
  has_many :reports,    through:   :dispatches
  has_many :shifts,     dependent: :destroy

  # CALLBACKS #
  after_validation :make_unavailable!, on: :update
  after_update :push_reports

  # SCOPES #
  default_scope ->    { where(role: 'responder') }
  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :on_shift, -> { where(id: Shift.on.map(&:responder_id)) }

  scope :available, lambda {
    find_by_sql(%Q{
      SELECT r.*, count(distinct d.id) as ad_count, count(distinct dr.id) as dr_count FROM users r
        LEFT JOIN dispatches d on d.responder_id=r.id
        LEFT JOIN dispatches dr on dr.responder_id=r.id AND dr.status not in ('pending', 'accepted')
      GROUP BY r.id
      HAVING count(distinct d.id) = count(distinct dr.id)
    }) & on_shift
  }

  # CLASS METHODS #
  def self.accepted(report_id)
    includes(:dispatches).where(
      dispatches: { report_id: report_id, status: %w(accepted completed) }
    )
  end

  # INSTANCE METHODS #
  def phone=(new_phone)
    write_attribute(:phone, NumberSanitizer.sanitize(new_phone))
  rescue NoMethodError
    errors.add(:phone, 'Phone Number is not valid')
  end

  def set_password
    self.password              = 'password'
    self.password_confirmation = 'password'
  end

  private

  def make_unavailable!
    shifts.end!('web') if active_changed? && !active
  end

  def push_reports
    Push.refresh
  end
end
