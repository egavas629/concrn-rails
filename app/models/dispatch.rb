class Dispatch < ActiveRecord::Base
  # RELATIONS #
  belongs_to :report
  belongs_to :responder
  delegate :name,    to: :responder, prefix: true
  delegate :address, to: :report,    prefix: true

  # CONSTANTS #
  STATUS = %w(accepted completed pending rejected)

  # VALIDATIONS #
  validates_presence_of :report
  validates_presence_of :responder
  validates_inclusion_of :status, in: STATUS

  # SCOPE #
  default_scope ->    { order(created_at: :desc) }
  scope :pending, ->  { where(status: 'pending') }
  scope :not_rejected, lambda {
    where.not(status: 'rejected').joins(:responder)
      .order('dispatches.status', 'dispatches.updated_at')
  }

  # CALLBACKS #
  after_create :messanger
  after_update :messanger, if: :status_changed?
  after_commit :push_reports

  # CLASS METHODS #
  def self.accepted(report_id = nil)
    query = where(status: %w(accepted completed)).order(:accepted_at)
    report_id ? query.where(report_id: report_id) : query
  end

  def self.completed_count(responder_id = nil)
    query = where(status: 'completed')
    query = responder_id ? query.where(responder_id: responder_id) : query
    query.count
  end

  def self.rejected_count(responder_id = nil)
    query = where(status: 'rejected')
    query = responder_id ? query.where(responder_id: responder_id) : query
    query.count
  end

  # INSTANCE METHODS #
  def accept!
    update_attributes(accepted_at: Time.now) if accepted?
  end

  def accepted?
    status == 'accepted'
  end

  def completed?
    status == 'completed'
  end

  def pending?
    status == 'pending'
  end

  def status_update
    [
      responder_name, status,
      (report_address.present? ? 'report @ ' + report_address : 'the report')
    ].join(' ')
  end

  private

  def messanger
    DispatchMessanger.new(responder).trigger
  end

  def push_reports
    Push.refresh
  end
end
