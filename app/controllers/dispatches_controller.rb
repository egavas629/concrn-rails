class DispatchesController < DashboardController
  def create
    if responder ? report.dispatch!(responder) : false
      flash[:notice] = "#{responder.name} has been dispatched to help #{report.name}."
    else
      flash[:alert] = "Please select a responder to dispatch."
    end
    redirect_to :back
  end

  def update
    dispatch = Dispatch.find(params[:id])
    if dispatch.update_attributes(dispatch_attributes)
      flash[:notice] = dispatch.status_update
      redirect_to :back
    end
  end

  def responder
    id = params.require(:dispatch).permit(:responder_id)[:responder_id]
    id.present? ? current_agency.responders.find(id) : false
  end

  def report
    current_agency.reports.find params.require(:dispatch).permit(:report_id)[:report_id]
  end

  private

  def dispatch_attributes
    params.require(:dispatch).permit(:status)
  end
end
