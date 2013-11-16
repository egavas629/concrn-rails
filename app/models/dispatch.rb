class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder

  validates_presence_of :report

  after_create :alert_responder
  after_create :alert_reporting_party

  private

  def alert_responder
    Message.send report.responder_synopsis, to: responder
  end

  def alert_reporting_party
    Message.send report.reporter_synopsis, to: report.phone
  end
end

# Time limit
