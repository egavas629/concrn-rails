class DispatchesController < ApplicationController
  def create
    if report.dispatch! responder
      flash[:notice] = "#{responder.name} has been dispatched to help #{report.name}."
      redirect_to :back
    end
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
    Responder.find params.require(:dispatch).permit(:responder_id)[:responder_id]
  end

  def report
    Report.find params.require(:dispatch).permit(:report_id)[:report_id]
  end

  private

  def dispatch_attributes
    params.require(:dispatch).permit(:status)
  end
end
