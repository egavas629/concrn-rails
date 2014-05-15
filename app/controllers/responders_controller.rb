class RespondersController < ApplicationController
  def index
    @responders = Responder.all
  end

  def new
    @responder = Responder.new
  end

  def create
    @responder = Responder.new(responder_params)

    # NOTE: take out once we use password/responder login
    @responder.set_password

    if @responder.save
      flash[:notice] = "#{@responder.name}'s profile was created"
      redirect_to action: :index
    else
      render :new
    end
  end

  def destroy
    @responder = Responder.find(params[:id])
    name = @responder.name
    if @responder.destroy
      flash[:notice] = "#{name}'s profile deleted"
      redirect_to action: :index
    else
      flash[:error] = 'Error in deleting Responder'
      redirect_to :back
    end
  end

  def by_phone
    @responder = Responder.where(phone: NumberSanitizer.sanitize(params[:phone])).first
    if @responder
      render json: @responder
    else
      head :not_found
    end
  end

  def show
    @responder = Responder.find(params[:id])
    render
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
    params.require(:responder).permit(:availability, :phone, :name, :email)
  end
end
