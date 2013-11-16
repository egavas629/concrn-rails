class DispatchesController < ApplicationController
  def create
    @dispatch = Dispatch.new(dispatch_params)
    if @dispatch.save
      flash[:notice] = "#{@dispatch.responder.name} has been dispatched"
      redirect_to reports_path
    end
  end

  def dispatch_params
    params.require(:dispatch).permit(:responder_id, :report_id)
  end
end
