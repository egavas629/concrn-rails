class PagesController < ApplicationController
  def home
    redirect_to edit_user_registration_path if user_signed_in?
  end
end
