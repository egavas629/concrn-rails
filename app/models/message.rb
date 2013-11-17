class Message
  def self.send(body, opts={})
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create(from: us, to: opts[:to], body: body )
  end

  def self.receive(body, opts={})
    responder = Responder.where(phone: opts[:from]).first
    responder.accept_dispatch
  end

  def us
    '(978) 566-1976'
  end
end
