class LogsController < ApplicationController
  def create
    log = Log.create! params.require(:log).permit [:body, :author_id, :report_id]

    redirect_to report_path(log.report)
  end

  def update
    log = Log.find params[:id]
    log.broadcast
    redirect_to report_path log.report
  end
end
