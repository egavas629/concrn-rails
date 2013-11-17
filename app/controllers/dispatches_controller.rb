class DispatchesController < ApplicationController
  def create
    if responder.dispatch_to(report)
      flash[:notice] = "#{responder.name} has been dispatched to #{report.name}'s crisis."
      redirect_to reports_path
    end
  end

  def responder
    Responder.find params.require(:dispatch).permit(:responder_id)[:responder_id]
  end

  def report
    Report.find params.require(:dispatch).permit(:report_id)[:report_id]
  end
end
