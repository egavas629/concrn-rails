class UsersController < ApplicationController
  before_filter :authenticate_user
  def home
    @user = current_user
  end
end
