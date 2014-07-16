class LogsController < DashboardController
  def create
    Log.create(log_params)
    render nothing: true, status: :ok
    # redirect_to report_path(log.report)
  end

  def update
    log = Log.find(params[:id])
    log.broadcast
    render nothing: true, status: :ok
  end

  private

  def log_params
    params.require(:log).permit(:body, :author_id, :report_id)
  end
end
