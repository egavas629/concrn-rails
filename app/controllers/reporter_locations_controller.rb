class ReporterLocationsController < ApplicationController

def create
  @reporterlocation = ReporterLocation.new(reporterlocation_params)
  @reporterlocation.save
  render json: {params}
end

private
  def reporterlocation_params
    params.permit(:lat, :long, :user_id)
  end
end
