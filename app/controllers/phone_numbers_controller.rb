class PhoneNumbersController < ApplicationController
  def new
    @phone_number = PhoneNumber.new
  end

  #Post route
  def create
    @phone_number = PhoneNumber.find_or_create_by(phone_number:params[:phone_number])
    @phone_number.generate_pin
    @phone_number.send_pin
    render json: {status: "sent"} #Sends back JSON object indicating message sent
  end

  #Post route
  def verify
    @phone_number = PhoneNumber.find_by(phone_number: params[:phone_number])
    @phone_number.verify(params[:pin])
    render json: {verified: @phone_number.verified} #Sends back Json object indicating whether number is verified
  end
end
