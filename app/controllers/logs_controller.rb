class LogsController < ApplicationController
  def create
    Log.create! params.require(:log).permit [:body, :author_id, :report_id]
    render nothing: true, status: :ok
    # redirect_to report_path(log.report)
  end

  def update
    log = Log.find params[:id]
    log.broadcast
    render nothing: true, status: :ok
    # redirect_to report_path log.report
  end
end
