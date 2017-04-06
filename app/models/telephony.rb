class Telephony
  OUTGOING_PHONE = ENV['SMS_PHONE'] || '(415) 801-3737'

  def self.client
    @client ||= Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
  end

  def self.send(body = 'Thanks!', to = nil)
    return Rails.logger.info("skipping SMS send('#{body}', '#{to}')") if Rails.env.test?

    client.account.messages.create(from: OUTGOING_PHONE, to: to, body: body)
  rescue => e
    puts "### ERROR: #{e} ###"
    puts "### MESSAGE NOT SENT TO #{to} ###"
  end

  def self.receive(body, opts = {})
    
    responder = Responder.find_by_phone(opts[:from])
    
    if responder
      # if txt msg from a responder, handle dispatcher/reporter interaction
      DispatchMessenger.new(responder).respond(body)
    else
      # text is from reporter, sends txt msg directly to Jacob
      send("#{opts[:from]}: #{opts[:body]}", to: Rails.configuration.backup_sms_phone)
    end

  end
end
