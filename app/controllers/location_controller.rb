class LocationController < ApplicationController

  def new
    @location = Location.new
  end

  def index
  if params[:search].present?
    @locations = Location.near(params[:search], 50, :order => :distance)
  else
    @locations = Location.all
  end
end
