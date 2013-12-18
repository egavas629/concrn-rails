class Message
  def self.send(body, opts={})
    Telephony.message to: opts[:to], body: body
  end

  def self.receive(body, opts={})
    responder = Responder.where(phone: opts[:from]).first
    send("#{opts[:from]} (Unknown)", to: "6507876770") unless responder
    responder.respond(body)
  end
end
