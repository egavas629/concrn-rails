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
    if request.xhr?
      @responder = Responder.find(params[:id])
    else
      @responder = Responder.where(phone: NumberSanitizer.sanitize(params[:id])).first
    end
    @responder.update_attributes(responder_params)
    Pusher.trigger("reports" , "refresh", {}) unless request.xhr?
    render json: @responder
  end

  def responder_params
    params.require(:responder).permit(:availability, :phone, :name)
  end
end
