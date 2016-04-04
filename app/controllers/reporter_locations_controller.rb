class ReporterLocationsController < ApplicationController

def create
  @reporterlocation = ReporterLocation.new(reporterlocation_params)
  @reporterlocation.save
  puts params, "*****"
  render json: params
end

private
  def reporterlocation_params
    params.permit(:latitude, :longitude, :user_id)
  end

end
