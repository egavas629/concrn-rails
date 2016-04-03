class UsersController < DashboardController
  before_filter :find_user, only: [:show, :update, :edit]
  # before_filter :authenticate_admin!,      only:   :create
  # before_filter :authenticate_user!,       except: [:create, :verify_responder_by_phone]
  # before_filter :authenticate_dispatcher!, except: [:create, :verify_responder_by_phone]

  def create
    @user = @agency.users.new(user_params)
    if @user.save
      flash[:notice] = "#{@user.name}'s profile was created"
      user_signed_in? ? (redirect_to action: :index) : (redirect_to :back)
    else
      flash[:notice] = @user.errors.full_messages.join(', ')
      user_signed_in? ? (render :new) : (redirect_to :back)
    end
  end

  # depracated 
  # def by_phone
  #   @user = current_agency.users.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
  #   if @user.present?
  #     render json: @user
  #   else
  #     head :not_found
  #   end
  # end

  def deactivated
    @responders = current_agency.responders.inactive
    @dispatchers = current_agency.dispatchers.inactive
  end

  def edit
  end

  def index
    @responders = current_agency.responders.active
    @dispatchers = current_agency.dispatchers.active
  end

  def new
    @user = current_agency.users.new
  end

  def show
    @user = @user.become_child
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)

        format.json {render json: @user}
        format.html {
          flash[:notice] = "#{@user.name} successfully updated"
          redirect_to @user
        }
      else
        format.json {render json: @user}
        format.html {
          flash[:notice] = "Error updating #{@user.name}"
          render action: :edit
        }
      end
    end
  end

  private

  def authenticate_admin!
    user_signed_in? && current_user.dispatcher? && a = true ||
    authenticate_super_admin! && a = false
    @agency = a ? current_agency : Agency.find(params[:user][:agency_id])
  end

  def find_user
    @user = users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:active, :phone, :name, :role, :email, :password, :password_confirmation)
  end
end
