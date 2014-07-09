class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable

  # RELATIONS #
  belongs_to :agency

  # CONSTANTS #
  ROLES = %w(responder dispatcher)

  # VALIDATIONS #
  validates :phone,  presence: true, uniqueness: true
  validates :name,   presence: true, uniqueness: { scope: :agency_id }
  validates :agency, presence: true
  validates_inclusion_of :role, in: ROLES

  # SCOPES #
  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :dispatchers, -> { where(role: 'dispatcher') }
  scope :responders,  -> { where(role: 'responder') }

  # INSTANCE METHODS #
  def become_child
    becomes(responder? ? Responder : Dispatcher)
  end

  def dispatcher?
    role == 'dispatcher'
  end

  def responder?
    role == 'responder'
  end

  def phone=(new_phone)
    write_attribute(:phone, NumberSanitizer.sanitize(new_phone))
  rescue NoMethodError
    errors.add(:phone, 'Phone Number is not valid')
  end
end
