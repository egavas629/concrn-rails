class Report < ActiveRecord::Base

  attr_accessor :delete_image
  serialize :observations, Array

  # RELATIONS #
  has_many :dispatches, dependent: :destroy
  has_many :logs,       dependent: :destroy
  has_many :responders, :through => :dispatches

  # CALLBACKS #
  has_attached_file :image

  before_validation { image.clear if delete_image == '1' }
  before_validation { observations.delete_if(&:empty?) if observations_changed? }
  after_validation  { set_completed! if status_changed? }

  # CONSTANTS #
  Gender            = ['Male', 'Female', 'Other']
  AgeGroups         = ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)']
  RaceEthnicity     = ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown']
  CrisisSetting     = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  CrisisObservation = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening']

  # SCOPE #
  scope :accepted, -> do
    includes(:dispatches).where(status: "pending").merge(Dispatch.accepted)
      .order("reports.created_at DESC").references(:dispatches)
  end

  scope :archived, -> { where(status: "archived") }
  scope :completed, -> { where("reports.status = 'archived' OR reports.status = 'completed'") }

  scope :pending, -> do
    includes(:dispatches).where(status: "pending").where.not(id: accepted.map(&:id))
      .where("dispatches.status = 'pending'").references(:dispatches)
  end

  scope :unassigned, -> do
    includes(:dispatches).where(status: 'pending')
      .where.not(id: pending.map(&:id).concat(accepted.map(&:id)))
  end

  # INSTANCE METHODS #
  def accepted_responders
    responders.includes(:dispatches).where(:dispatches => {report_id: id, status: %w(accepted completed)})
  end

  def accepted_dispatches
    dispatches.accepted.order('created_at DESC')
  end


  def current_status
    if status == 'pending'
      if accepted_dispatches.present?
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
    dispatches.create!(responder: responder)
  end

  def dispatched?
    dispatches.keep_if {|i| i.responder.present? }.size > 0
  end

  def unassigned?
    !dispatched? || dispatches.all?(&:rejected?)
  end

  def accepted?
    accepted_responders.any?
  end

  def archived?
    status == 'archived'
  end

  def completed?
    status == 'completed'
  end

  def archived_or_completed?
    %w(archived completed).include?(status)
  end

  def complete!
    update_attribute(:status, 'completed')
  end

  def set_completed!
    if %w(archived completed).include?(status)
      update_attributes(completed_at: Time.now) unless completed_at.present?
      dispatches.pending.each {|i| i.update_attribute(:status, 'rejected')}
      accepted_dispatches.each {|i| i.update_attribute(:status, 'completed')}
    end
  end

  def accept_feedback(opts={})
    logs.create! author: opts[:from], body: opts[:body]
  end

  def google_maps_address
    "https://maps.google.com/?q=#{address}"
  end

# TODO: Write CSS rules for actual statuses, and get rid of this method.
  def table_status
    {
      'rejected'      => 'danger',
      'pending'       => 'warning',
      'accepted'      => 'active',
      'archived'      => 'info',
      'completed'     => 'success',
      'unassigned'    => 'warning'
    }.fetch(status)
  end
end
