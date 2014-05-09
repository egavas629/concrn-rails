class Report < ActiveRecord::Base
  validates_presence_of :agency
  belongs_to :agency
  has_many :dispatches
  has_many :logs

  # Comment out style gives options to upload other types of files
  has_attached_file :image #, :styles => { :medium => "600x600>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_plausible_phone :phone, presence: true, country_code: 'US'

  Gender = ['Male', 'Female', 'Other']
  AgeGroups = ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)']
  RaceEthnicity = ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian',
    'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown']
  CrisisSetting = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  CrisisObservation = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed',
    'Aggarvated', 'Threatening']

  def responder
    current_dispatch.responder if dispatched?
  end

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
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "pending"}).order("created_at desc")
  end

  def self.accepted
    joins(:dispatches).where(status: "pending").where(dispatches: {status: "accepted"}).order("created_at desc")
  end

  def self.deleted
    where(status: "deleted")
  end

  def self.completed
    find_by_sql(%Q{
      SELECT r.* FROM reports r
        LEFT JOIN dispatches d on d.report_id=r.id
      WHERE r.status = 'completed' or d.status = 'completed'
      ORDER BY r.created_at desc
    })
  end

  def pending?
    current_dispatch && current_dispatch.pending?
  end

  def accepted?
    current_dispatch && current_dispatch.accepted?
  end

  def completed?
    current_dispatch && current_dispatch.completed?
  end

  def responder_synopses
    [
      address,
      "Reporter: #{name}, #{phone}",
      "#{race}/#{gender}/#{age}",
      setting,
      nature
    ]
  end

  def current_dispatch
    dispatches.last
  end

  def reporter_synopsis
    <<-SMS
    CRISIS RESPONSE:
    #{current_dispatch.responder.name} is on the way.
    #{current_dispatch.responder.phone}
    SMS
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
    dispatches.create!(responder: responder) if unassigned?
    # Only one responder, for now: only unassigned reports are eligible for dispatch.
  end

  def dispatched?
    dispatches.any?
  end

  def unassigned?
    !dispatched? || dispatches.all?(&:rejected?)
  end

  def status
    valid_dispatch = dispatches.not_rejected.latest
    valid_dispatch.present? ? valid_dispatch.status : "unassigned"
  end

  def deleted?
    attributes["status"] == "deleted"
  end

  def accept_feedback(opts={})
    logs.create! author: opts[:from], body: opts[:body]
  end

  def google_maps_address
    "https://maps.google.com/?q=#{address}"
  end

end
