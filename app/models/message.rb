class Message
  def self.send(body, to: to)
    Telephony.message body: body, to: to
  end

  def self.receive(body, opts={})
    responder = Responder.where(phone: opts[:from]).first
    send("#{opts[:from]} (Unknown)", to: "6507876770") unless responder
    responder.respond(body)
  end
end
