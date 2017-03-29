class Client < ActiveRecord::Base
  include CsvExportable
  sensitive_fields :name

  # RELATIONS #
  has_many :reports

  AGEGROUP    = [
    'Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)'
  ]
  GENDER      = %w(Male Female Other)
  ETHNICITY   = [
    'Hispanic or Latino', 'American Indian or Alaska Native', 'Asian',
    'Black or African American', 'Native Hawaiian or Pacific Islander',
    'White', 'Other/Unknown'
  ]

  validates_inclusion_of :gender, in: GENDER, allow_blank: true
  validates_inclusion_of :age, in: AGEGROUP, allow_blank: true
  validates_inclusion_of :race, in: ETHNICITY, allow_blank: true

  # CALLBACKS #

  # SCOPES #
  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }

  # CLASS METHODS #

  # INSTANCE METHODS #
  private
end
