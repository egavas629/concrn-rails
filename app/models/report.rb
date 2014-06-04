class Report < ActiveRecord::Base

  attr_accessor :delete_image

  # RELATIONS #
  has_many :dispatches, dependent: :destroy
  has_many :logs,       dependent: :destroy
  has_many :responders, :through => :dispatches

  # CALLBACKS #
  has_attached_file :image

  before_validation { image.clear if delete_image == '1' }

  # CONSTANTS #
  Gender            = ['Male', 'Female', 'Other']
  AgeGroups         = ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)']
  RaceEthnicity     = ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown']
  CrisisSetting     = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  CrisisObservation = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening']

  # CLASS METHODS #
  def self.unassigned
    find_by_sql(<<-SQL)
      SELECT r.*, count(distinct d.id) as ad_count, count(distinct dr.id) as dr_count FROM reports r
        LEFT JOIN dispatches d on d.report_id=r.id
        LEFT JOIN dispatches dr on dr.report_id=r.id AND dr.status='rejected'
      WHERE r.status = 'pending'
      GROUP BY r.id
      HAVING count(distinct d.id) = count(distinct dr.id)
    SQL
  end

  def self.pending
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "pending"}).order("created_at desc").uniq
  end

  def self.accepted
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "accepted"}).order("created_at desc").uniq
  end

  def self.archived
    where(status: "archived")
  end

  def self.completed
    joins("LEFT JOIN dispatches on dispatches.report_id=reports.id")
      .where("reports.status = 'archived' OR dispatches.status = 'completed'")
      .order("reports.created_at desc")
  end

  # INSTANCE METHODS #
  def accepted_responders
    responders.joins(:dispatches).where(:dispatches => {report_id: id, status: 'accepted'})
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

  def complete!
    changes                = Hash.new
    changes[:status]       = 'archived' unless archived?
    changes[:completed_at] = Time.now if completed_at.nil?
    update_attributes(changes)
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
