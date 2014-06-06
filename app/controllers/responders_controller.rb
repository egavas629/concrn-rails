class RespondersController < ApplicationController
  before_action :find_responder, only: %w(destroy show update)
  before_action :new_responder, only: %w(new create)

  def index
    @responders = Responder.active
  end

  def deactivated
    @responders = Responder.inactive
  end

  def new
  end

  def show
  end

  def create
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
    @responder = Responder.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
    if @responder
      render json: @responder
    else
      head :not_found
    end
  end

  def update
    @responder.update_attributes(responder_params)
    Pusher.trigger("reports" , "refresh", {}) unless request.xhr?
    respond_to do |format|
      format.json {render json: @responder}
      format.html {render action: :show}
    end
  end

  private

  def new_responder
    @responder = Responder.new(responder_params)
  end

  def find_responder
    @responder = Responder.find(params[:id])
  end

  def responder_params
    params.require(:responder).permit(:availability, :phone, :name, :email, :active)
  end
end
