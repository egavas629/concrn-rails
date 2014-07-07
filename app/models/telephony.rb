class Telephony
  OUTGOING_PHONE = ENV['SMS_PHONE'] || '(415) 801-3737'

  def self.client
    @client ||= Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
  end

  def self.send(body='Thanks!', to=nil)
    if Rails.env.test?
      true
    else
      sleep 1 # Carriers are sloppy.
      client.account.messages.create(from: OUTGOING_PHONE, to: to, body: body)
    end
  rescue => e
    puts "### ERROR: #{e} ###"
    puts "### MESSAGE NOT SENT TO #{to} ###"
  end

  def self.receive(body, opts={})
    responder = Responder.find_by_phone(opts[:from])
    send("#{opts[:from]}: #{opts[:body]}", to: "6507876770") unless responder
    messanger = DispatchMessanger.new(responder)
    messanger.respond(body)
  end
end
