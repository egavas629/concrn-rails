class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def current_agency
    current_user.try(:agency)
  end
  helper_method :current_agency

  def authenticate_dispatcher!
    return true if user_signed_in? && current_user.dispatcher?
    flash[:error] = 'Page is unaccessable please contact Agency Admin if you think this is by mistake.'
    redirect_to root_path
  end
end
