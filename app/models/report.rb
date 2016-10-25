require 'httparty'

class Report < ActiveRecord::Base
  include HTTParty
  include PgSearch

  DEFAULT_TEAM_NAME = "Concrn Team"
  attr_accessor :delete_image
  serialize :observations, Array
  reverse_geocoded_by :lat, :long do |obj, results|
    obj.zip ||= results.first.postal_code if results.first
  end
  after_validation :reverse_geocode

  # RELATIONS #
  has_many :dispatches, dependent: :destroy
  has_many :logs,       dependent: :destroy
  has_many :responders, through:   :dispatches
  has_many :uploads, dependent: :destroy
  belongs_to :client

  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true

  # CALLBACKS #
  has_attached_file :image
  before_validation :clean_image, :clean_observations
  after_validation :set_completed, if: :archived_or_completed?, on: :update
  after_commit :push_reports
  after_create :send_to_dispatcher

  URGENCY_LABELS = ['Not urgent', 'This week', 'Today', 'Within an hour', 'Need help now']
  SETTING = ['Public Space', 'Workplace', 'School', 'Home', 'Other']
  OBSERVATION = ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggravated', 'Threatening' ]
  STATUS = %w(archived completed pending)

  # VALIDATIONS #
  validates :address, presence: true
  validates_inclusion_of :status, in: STATUS
  validates_inclusion_of :gender, in: Client::GENDER, allow_blank: true
  validates_inclusion_of :age, in: Client::AGEGROUP, allow_blank: true
  validates_inclusion_of :race, in: Client::ETHNICITY, allow_blank: true
  validates_inclusion_of :setting, in: SETTING, allow_blank: true
  validates_attachment :image, :content_type => { :content_type => %w(image/jpeg image/jpg image/png) }

  # SCOPE #
  scope :accepted, lambda {
    joins(:dispatches).where(dispatches: {status: 'accepted'})
  }

  scope :completed, -> { where(status: %w(completed archived)) }

  scope :pending, lambda {
    joins(:dispatches).where(dispatches: {status: 'pending'}).distinct
  }

  scope :unassigned, lambda {
    includes(:dispatches).where(status: 'pending')
      .where.not(id: pending.pluck(:id).concat(accepted.pluck(:id)))
  }

  scope :by_oldest, -> { order("reports.created_at ASC") }
  scope :by_newest, -> { order("reports.created_at DESC") }

  pg_search_scope :keyword_search, :against => [:name, :phone, :observations, :feedback, :neighborhood, :zip, :address, :status, :race, :gender], :associated_against => {
      :responders => [:name]
    }, :order_within_rank => "reports.created_at DESC"

  # INSTANCE METHODS #
  def accepted_dispatches
    dispatches.accepted
  end

  def multi_accepted_responders?
    accepted_dispatches.count > 1
  end

  def primary_responder
    return false if accepted_dispatches.blank?
    accepted_dispatches.oldest.responder
  end

  def current_status
    return 'completed' if completed?
    return 'active' if active?
    return 'pending' if pending?
    return 'archived' if archived?
    return 'unassigned'
  end

  def dispatch(responder)
    dispatches.create(responder: responder)
  end

  def accepted?
    Responder.accepted(id).any?
  end

  def archived?
    status == 'archived'
  end
  
  def pending?
    dispatches
      .where.not(status: 'accepted')
      .where.not(status: 'completed')
      .where.not(status: 'rejected').any?
  end

  def active?
    dispatches.where(status: 'accepted').any?
  end
  
  def completed?
    dispatches.where(status: 'completed').any?
  end

  def archived_or_completed?
    archived? || completed?
  end

  def complete
    update_attributes(status: 'completed')
  end

  def set_completed
    return false unless %w(archived completed).include?(status)
    touch(:completed_at) unless completed_at.present?
    dispatches.pending.each { |i| i.update_attributes(status: 'rejected') }
    Dispatch.accepted(id).each { |i| i.update_attributes(status: 'completed') }
  end

  def neighborhood
    read_attribute(:neighborhood) || update_attribute(:neighborhood, Neighborhood.at(lat, long)) && read_attribute(:neighborhood)
  end

  def get_similar_reports(number_of_reports = 5)
    similar_reports = Report
      .where("gender = ? OR gender = ?", self.gender, 'Other')
      .where(age: self.age)
      .where.not(id: self.id)
      .to_a

    similar_reports.sort_by! do |report|
      0 - get_similarity_score(report)
    end

    similar_reports.first(number_of_reports)
  end

  private

  def send_to_dispatcher
    Dispatcher.on_shift.each do |dispatcher|
      Telephony.send("New Report @ #{address}. www.concrn.com/reports", dispatcher.phone)
    end
  end

  def clean_image
    image.clear if delete_image == '1'
  end

  def clean_observations
    observations.delete_if(&:blank?) if observations_changed?
  end

  def push_reports
    Push.refresh
  end

  def score_for_matched_observations(observations)
    observations.reduce(0) do |sum, observation|
      sum += 0.1 if self.observations.include?(observation)
    end
  end

  def get_similarity_score(other_report)
    score = 0
    self_report_time = self.created_at.hour * 60 + self.created_at.min
    other_report_time = other_report.created_at.hour * 60 + other_report.created_at.min

    score += 0.33 if other_report.race == self.race

    # unweighting these, but could be possible alterations to the algorithm
    #score += score_for_matched_observations(other_report.observations)
    #score += 0.33 if (other_report_time - self_report_time).abs <= 2 * 60

    score
  end
end
