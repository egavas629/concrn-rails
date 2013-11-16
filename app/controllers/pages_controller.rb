class PagesController < ApplicationController
  def home
    redirect_to :reports if user_signed_in?
  end
end
