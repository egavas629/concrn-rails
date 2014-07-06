class Report < ActiveRecord::Base

  attr_accessor :delete_image
  serialize :observations, Array

  # RELATIONS #
  has_many :dispatches, dependent: :destroy
  has_many :logs,       dependent: :destroy
  has_many :responders, through:   :dispatches

  # CALLBACKS #
  has_attached_file   :image
  before_validation   :clean_image, :clean_observations
  after_validation    :set_completed!, if: :archived_or_completed?
  after_commit        :push_reports

  # CONSTANTS #
  AgeGroups         = ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)']
  CrisisSetting     = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  CrisisObservation = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening']
  Gender            = ['Male', 'Female', 'Other']
  RaceEthnicity     = ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown']
  Status            = ['archived', 'completed', 'pending']

  # VALIDATIONS #
  validates :address, presence: true
  validates_inclusion_of :status, in: Status
  validates_inclusion_of :gender, in: Gender, allow_nil: true
  validates_inclusion_of :age, in: AgeGroups, allow_nil: true
  validates_inclusion_of :race, in: RaceEthnicity, allow_nil: true
  validates_inclusion_of :setting, in: CrisisSetting, allow_nil: true

  # SCOPE #
  scope :accepted, -> do
    includes(:dispatches).where(status: "pending").merge(Dispatch.accepted)
      .order("reports.created_at DESC").references(:dispatches)
  end

  scope :completed, -> { where(status: %w(completed archived)) }

  scope :pending, -> do
    includes(:dispatches).where(status: "pending").where.not(id: accepted.map(&:id))
      .where("dispatches.status = 'pending'").references(:dispatches)
  end

  scope :unassigned, -> do
    includes(:dispatches).where(status: 'pending')
      .where.not(id: pending.map(&:id).concat(accepted.map(&:id)))
  end

  # INSTANCE METHODS #
  def current_status
    if status == 'pending'
      if Dispatch.accepted(id).present?
        'active'
      elsif current_pending?
        'pending'
      else
        'unassigned'
      end
    else
      status
    end
  end

  def current_pending?
    Report.pending.include?(self)
  end

  def dispatch!(responder)
    dispatches.create!(responder: responder)
  end

  def accepted?
    Responder.accepted(id).any?
  end

  def archived?
    status == 'archived'
  end

  def completed?
    status == 'completed'
  end

  def archived_or_completed?
    archived? || completed?
  end

  def complete!
    update_attributes!(:status => 'completed')
  end

  def set_completed!
    if %w(archived completed).include?(status)
      update_attributes(completed_at: Time.now) unless completed_at.present?
      dispatches.pending.each {|i| i.update_attribute(:status, 'rejected')}
      Dispatch.accepted(id).each {|i| i.update_attribute(:status, 'completed')}
    end
  end

private

  def clean_image
    image.clear if delete_image == '1'
  end

  def clean_observations
    observations.delete_if(&:blank?) if observations_changed?
  end

  def push_reports
    Push.refresh
  end
end
