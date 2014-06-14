class Responder < User
  # RELATIONS #
  has_many :reports, through: :dispatches
  has_many :dispatches

  # VALIDATIONS #
  validates_presence_of :phone

  # CALLBACKS #
  after_validation :make_unavailable!, :on => :update, if: :need_to_make_unavailable?

  # SCOPES #
  default_scope -> { where(role: 'responder') }
  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  scope :available, -> do
    find_by_sql(%Q{
      SELECT r.*, count(distinct d.id) as ad_count, count(distinct dr.id) as dr_count FROM users r
        LEFT JOIN dispatches d on d.responder_id=r.id
        LEFT JOIN dispatches dr on dr.responder_id=r.id AND dr.status not in ('pending', 'accepted')
      WHERE r.role = 'responder'
      AND r.availability = true
      GROUP BY r.id
      HAVING count(distinct d.id) = count(distinct dr.id)
    })
  end

  # INSTANCE METHODS #
  def phone=(new_phone)
    write_attribute :phone, NumberSanitizer.sanitize(new_phone)
  end

  def completed_count
    dispatches.where(status: "completed").count
  end

  def rejected_count
    dispatches.where(status: "rejected").count
  end

  def status
    return "unassigned" if dispatches.none?
    "last: #{dispatches.latest.status}"
  end

  def set_password
    self.password              = 'password'
    self.password_confirmation = 'password'
  end

  private

  def make_unavailable!
    update_attribute(:availability, false)
  end

  def need_to_make_unavailable?
    active_changed? && !active
  end
end
