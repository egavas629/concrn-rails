class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

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
