class Api::PhoneNumbersController < ApplicationController
  def new
    @phone_number = PhoneNumber.new
  end

  #Post route
  def create
    phone = NumberSanitizer.sanitize(params[:phone])
    if phone == nil || phone.length > 10 || phone.length < 9
      render json: {status: "failed", reason: "Invalid Phone Number"}
    else 
      if phone.length == 9
        phone = "1" + phone
      end
      @phone_number = PhoneNumber.find_or_create_by(phone_number:phone)
      @phone_number.generate_pin
      @phone_number.send_pin
      render json: {status: "sent"}
    end
  end

  #Post route
  def verify
    @phone_number = PhoneNumber.find_by(phone_number: params[:phone])
    render json: {verified: @phone_number.verify(params[:code])} #Sends back Json object indicating whether number is verified
  end
end
