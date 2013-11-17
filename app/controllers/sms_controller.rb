class SmsController < ActionController::Base
  def create
    incoming_number = NumberSanitizer.sanitize(params["From"])
    Rails.logger.info "MESSAGE FROM #{incoming_number}: #{params["Body"]}"
    Message.receive params["Body"], from: incoming_number
    head :ok
  end
end
