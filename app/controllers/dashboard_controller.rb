class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def authenticate_dispatcher!
    return true if user_signed_in? && current_user.dispatcher?
    flash[:error] = 'Page is unaccessable please contact Agency Admin if you think this is by mistake.'
    redirect_to root_path
  end
end
