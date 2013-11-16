class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder

  after_create :alert_responder

  private

  def alert_responder
    account_sid = 'ACe64730f8ebb4ad01757190b41167029d'
    auth_token = 'b23b2285e727481056ad1003ddbc02cf'

    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create(
      :from => '(978) 566-1976',
      :to => '6507876770'||responder.phone,
      :body => report.synopsis
    )
  end
end

# Time limit
