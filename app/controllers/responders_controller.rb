class RespondersController < ApplicationController
  def index
    @responders = Responder.all
  end

  def by_phone
    @responder = Responder.where(phone: NumberSanitizer.sanitize(params[:phone])).first
    if @responder
      render json: @responder
    else
      head :not_found
    end
  end

  def update
    @responder = Responder.where(phone: NumberSanitizer.sanitize(params[:id])).first
    @responder.update_attributes(responder_params)
    render json: @responder
  end

  def responder_params
    params.require(:responder).permit(:availability, :phone, :name)
  end
end
