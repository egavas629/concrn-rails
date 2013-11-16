class Message
  def self.send(body, opts={})
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create(
      from: '(978) 566-1976',
      to: opts[:to],
      body: body
    )
  end
end
