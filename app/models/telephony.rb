class Telephony
  OUTGOING_PHONE = ENV['SMS_PHONE'] || '(978) 566-1976'

  def self.client
    @client ||= Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
  end

  def self.send to: nil, body: 'Thanks!'
    sleep 1 # Carriers are sloppy.
    client.account.messages.create(from: OUTGOING_PHONE, to: to, body: body)
  end

  def self.receive(body, opts={})
    responder = Responder.where(phone: opts[:from]).first
    send("#{opts[:from]}: #{opts[:body]}", to: "6507876770") unless responder
    DispatchMessanger.new(responder, body)
  end
end
