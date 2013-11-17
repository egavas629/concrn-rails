class Message
  OUTGOING_PHONE = '(978) 566-1976'

  def self.send(body, opts={})
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create(from: OUTGOING_PHONE, to: opts[:to], body: body )
  end

  def self.receive(body, opts={})
    responder = Responder.where(phone: opts[:from]).first
    send("#{opts[:from]} (Unknown)", to: "6507876770") unless responder
    responder.respond(body)
  end
end
