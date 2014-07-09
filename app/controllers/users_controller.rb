class UsersController < DashboardController
  before_filter :find_user, only: [:show, :update, :edit]
  before_filter :authenticate_dispatcher!

  def create
    @user = current_agency.users.new(user_params)
    if @user.save
      flash[:notice] = "#{@user.name}'s profile was created"
      redirect_to action: :index
    else
      render :new
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
    @users =  User.inactive
  end

  def edit
  end

  def index
    @users =  User.active
  end

  def new
    @user = User.new
  end

  def show
    @user = @user.become_child
  end

  def update
    @user.update_attributes(user_params)
    respond_to do |format|
      format.json {render json: @user}
      format.html {redirect_to @user}
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:active, :phone, :name, :role, :email, :password, :password_confirmation)
  end
end
