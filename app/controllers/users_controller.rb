class UsersController < DashboardController
  before_filter :find_user, only: [:show, :update, :edit]
  before_filter :authenticate_admin!,      only:   :create
  before_filter :authenticate_user!,       except: :create
  before_filter :authenticate_dispatcher!, except: :create

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{@user.name}'s profile was created"
      user_signed_in? ? (redirect_to action: :index) : (redirect_to :back)
    else
      flash[:notice] = @user.errors.full_messages.join(', ')
      user_signed_in? ? (render :new) : (redirect_to :back)
    end
  end

  def by_phone
    @user = User.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
    if @user.present?
      render json: @user
    else
      head :not_found
    end
  end

  def deactivated
    @responders = Responder.inactive
    @dispatchers = Dispatcher.inactive
  end

  def edit
  end

  def index
    @responders = Responder.active
    @dispatchers = Dispatcher.active
  end

  def new
    @user = User.new
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
    user_signed_in? && (current_user.dispatcher? || authenticate_super_admin!)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:active, :phone, :name, :role, :email, :password, :password_confirmation)
  end
end
