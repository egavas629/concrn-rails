class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder
  validates_presence_of :report
  validates_presence_of :responder

  after_commit :alert_responder

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

  def accept!
    alert_reporting_party if update_attributes!(status: 'accepted')
  end

  def completed?
    status == "completed"
  end

  private

  def alert_responder
    Message.send report.responder_synopsis, to: '6502481396'||responder
  end

  def alert_reporting_party
    Message.send report.reporter_synopsis, to: '6507876770'||report.phone
  end
end
