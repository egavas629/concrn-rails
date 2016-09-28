class ReportersController < DashboardController
  before_filter :authenticate_user!,       except: [:new, :create]

  def show
    @reports  = Report.where(reporter_params)
    @key_info = params['name'] || params['phone'] || params['address']
    render
  end

  def new
  	@reporter = Reporter.new
  end

  def create
    @reporter = Reporter.new(reporter_params)
    if @reporter.save
      flash[:notice] = "#{@reporter.name}'s profile was created"
      sign_in(:user, @reporter)
      user_signed_in? ? (redirect_to controller: 'reports', action: 'new') : (redirect_to :back)
    else
      flash[:notice] = @reporter.errors.full_messages.join(', ')
      user_signed_in? ? (render :new) : (redirect_to :back)
    end
  end

  private

  def reporter_params
    params.require(:reporter).permit(:phone, :name, :email, :password, :password_confirmation, :address)
  end
end
