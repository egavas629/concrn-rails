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

  # CONSTANTS #
  Gender            = ['Male', 'Female', 'Other']
  AgeGroups         = ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)']
  RaceEthnicity     = ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown']
  CrisisSetting     = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  CrisisObservation = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening']

  # SCOPE #
  scope :accepted, -> do
    joins(:dispatches).where(status: "pending")
      .merge(Dispatch.accepted).order("created_at desc")
  end

  scope :archived, -> { where(status: "archived") }

  scope :completed, -> do
    joins("LEFT JOIN dispatches on dispatches.report_id=reports.id")
      .where("reports.status = 'archived' OR dispatches.status = 'completed'")
      .order("reports.created_at desc")
  end

  scope :pending, -> do
    joins(:dispatches).where(status: "pending")
      .where.not(id: accepted.map(&:id)).uniq
  end

  scope :unassigned, -> do
    includes(:dispatches).where(status: 'pending')
      .where(dispatches: {report_id: nil})
  end

  # INSTANCE METHODS #
  def accepted_responders
    responders.includes(:dispatches).where(:dispatches => {report_id: id, status: 'accepted'})
  end

  def accepted_dispatches
    dispatches.accepted.order('created_at DESC')
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

  def complete!
    changes                = Hash.new
    changes[:status]       = 'archived' unless archived?
    changes[:completed_at] = Time.now if completed_at.nil?
    dispatches.pending.each {|i| i.update_attribute(:status, 'rejected')} if update_attributes(changes)
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
      'unassigned'    => 'warning'
    }.fetch(status)
  end
end
