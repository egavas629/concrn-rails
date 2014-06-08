class DispatchesController < ApplicationController
  def create
    if responder ? report.dispatch!(responder) : false
      flash[:notice] = "#{responder.name} has been dispatched to help #{report.name}."
    else
      flash[:alert] = "Please select a responder to dispatch."
    end
    redirect_to :back
  end

  def update
    @dispatch = Dispatch.find(params[:id])
    if @dispatch.update_attributes(dispatch_attributes)
      address = @dispatch.report.address
      flash[:notice] = "#{@dispatch.responder.name} #{@dispatch.status} #{address.present? ? ('report @ ' + address) : 'the report'}"
      redirect_to :back
    end
  end

  def responder
    id = params.require(:dispatch).permit(:responder_id)[:responder_id]
    id.present? ? Responder.find(id) : false
  end

  def report
    Report.find params.require(:dispatch).permit(:report_id)[:report_id]
  end

  private

  def dispatch_attributes
    params.require(:dispatch).permit(:status)
  end
end
