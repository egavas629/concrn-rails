class SmsController < ActionController::Base
  def index
    incoming_number = NumberSanitizer.sanitize(params["From"])
    Message.receive params["Body"], from: incoming_number
    head :ok
  end
end
