class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
    @dispatched_reports = Report.dispatched
    @pending_reports = Report.pending
  end

  def create
    @report = Report.create(report_params)
    if @report.save
      Pusher.trigger("reports" , "report_created", @report.attributes)
      render json: @report
    else
      render json: @report
    end
  end

  def update
    @report = Report.find(params[:report]).update_attributes(report_params)
  end

  def report_params
    params.require(:report).permit(:name, :phone, :lat, :long, :status, :description)
  end
end
