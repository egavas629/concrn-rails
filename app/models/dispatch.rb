class Dispatch < ActiveRecord::Base
  # RELATIONS #
  belongs_to :report
  belongs_to :responder
  delegate :name,    to: :responder, prefix: true
  delegate :address, to: :report,    prefix: true

  # VALIDATIONS #
  validates_presence_of :report
  validates_presence_of :responder

  # SCOPE #
  default_scope    -> { order(created_at: :desc) }
  scope :accepted, -> { where(status: %w(accepted completed)) }
  scope :pending,  -> { where(status: 'pending') }

  scope :not_rejected, -> do
    where.not(status: 'rejected')
      .joins(:responder).order('dispatches.status', 'dispatches.updated_at')
  end

  # CALLBACKS #
  after_create :messanger
  after_update :messanger, if: :status_changed?
  after_commit :push_reports

  # CLASS METHODS #
  def self.latest
    first
  end

  # INSTANCE METHODS #
  def accepted?
    status == "accepted"
  end

  def completed?
    status == "completed"
  end

  def pending?
    status == "pending"
  end

  def status_update
    "#{responder_name} #{status} #{report_address.present? ? 'report @ ' + report_address : 'the report'}"
  end

private

  def messanger
    dispatch_messanger = DispatchMessanger.new(responder)
    case status
    when 'accepted'
      dispatch_messanger.accept!
    when 'completed'
      dispatch_messanger.complete!
    when 'pending'
      dispatch_messanger.pending!
    when 'rejected'
      dispatch_messanger.reject!
    end
  end

  def push_reports
    Pusher.trigger('reports-responders' , "refresh", {})
  end

end
