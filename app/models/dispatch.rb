class Dispatch < ActiveRecord::Base
  # RELATIONS #
  belongs_to :report
  belongs_to :responder

  # VALIDATIONS #
  validates_presence_of :report
  validates_presence_of :responder

  # SCOPE #
  default_scope { order(:created_at) }
  scope :accepted,     -> { where(status: %w(accepted completed)) }
  scope :not_rejected, -> { where.not(status: 'rejected') }
  scope :pending,      -> { where(status: 'pending') }

  # CALLBACKS #
  after_commit :alert_responder, on: :create

  # CLASS METHODS #
  def self.latest
    order('created_at desc').first
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

  def rejected?
    status == "rejected"
  end

  def accept!
    if update_attributes!(status: 'accepted')
      update_dispatch
      acknowledge_acceptance
      notify_reporter
    end
  end

  def reject!
    update_dispatch
    update_attributes!(status: 'rejected')
    acknowledge_rejection
  end

  def complete!
    if update_attributes!(status: 'completed')
      thank_responder
      thank_reporter
      report.complete!
    end
  end

  private

  def thank_responder
    Message.send "Thanks for your help. You are now available to be dispatched.", to: responder.phone
  end

  def thank_reporter
    Message.send "Report resolved, thanks for being concrned!", to: report.phone
  end

  def acknowledge_rejection
    Message.send "We appreciate your timely rejection. Your report is being re-submitted.", to: responder.phone
  end

  def alert_responder
    puts '~~~~~~~~~~~~~~~~'
    puts '~~~~~~~~~~~~~~~~'
    puts '~~~~~~~~~~~~~~~~'
    puts '~~~~~~~~~~~~~~~~'
    Message.send responder_synopsis, to: responder.phone
  end

  def responder_synopsis
    [
      report.address,
      "Reporter: #{report.name}, #{report.phone}",
      "#{report.race}/#{report.gender}/#{report.age}",
      report.setting,
      report.nature
    ]
  end

  def notify_reporter
    Message.send reporter_synopsis, to: report.phone
  end

  def reporter_synopsis
    <<-SMS
    INCIDENT RESPONSE:
    #{responder.name} is on the way.
    #{responder.phone}
    SMS
  end

  def update_dispatch
    Pusher.trigger("reports" , "refresh", report)
  end

  def acknowledge_acceptance
    Message.send "You have been assigned to an incident at #{report.address}.", to: responder.phone
  end
end
