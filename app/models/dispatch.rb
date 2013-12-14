class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder
  validates_presence_of :report
  validates_presence_of :responder

  after_commit :alert_responder, on: :create

  def self.latest
    order('created_at desc').first
  end

  def rejected?
    status == "rejected"
  end

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def completed?
    status == "completed"
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
    end
  end

  private

  def thank_responder
    Message.send "Thanks for your help. You are now available to be dispatched.", to: responder.phone
  end

  def thank_reporter
    Message.send "Crisis resolved, thanks for being a streetmom.", to: report.phone
  end

  def acknowledge_rejection
    Message.send "We appreciate your timely rejection. Your report is being re-submitted.", to: responder.phone
  end

  def alert_responder
    Message.send report.responder_synopsis, to: responder.phone
  end

  def notify_reporter
    Message.send report.reporter_synopsis, to: report.phone
  end

  def update_dispatch
    Pusher.trigger("reports" , "refresh", report)
  end

  def acknowledge_acceptance
    Message.send "You have been assigned to the crisis at #{report.address}.", to: responder.phone
  end
end
