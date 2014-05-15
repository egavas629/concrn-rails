class Telephony
  OUTGOING_PHONE = ENV['SMS_PHONE'] || '(978) 566-1976'

  def self.message to: nil, body: 'Thanks!'
    client.account.messages.create(from: OUTGOING_PHONE, to: to, body: body)
  end

  def self.client
    @client ||= Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
  end
end
