class DispatchesController < ApplicationController
  def create
    Dispatch.create!(params[:dispatch])
  end
end
