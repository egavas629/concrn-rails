class DispatchesController < ApplicationController
  def create
    if dispatch = Dispatch.create!(dispatch_params)
      flash[:notice] = "#{dispatch.responder.name} has been dispatched"
      redirect_to reports_path
    end
  end

  def dispatch_params
    params.require(:dispatch).permit(:responder_id, :report_id)
  end
end
