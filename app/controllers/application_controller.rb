class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :redirect_to_org

  def authenticate_super_admin!
    authenticate_or_request_with_http_basic do |username, password|
      ENV['SUPER_ADMIN_USERNAME'] == username &&
      ENV['SUPER_ADMIN_PASSWORD'] == password
    end
  end

  def current_agency
    return false unless user_signed_in?
    current_user.agency
  end
  helper_method :current_agency

  def redirect_to_org
    Rails.logger.info request.env["HTTP_USER_AGENT"]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :phone
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :phone
  end

  def after_sign_in_path_for(user)
    user.role == "dispatcher" ? reports_path : edit_user_registration_path
  end
end
