class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
    @dispatched_reports = Report.dispatched
    @pending_reports = Report.pending
  end

  def create
    render json: Report.create!(report_params)
  end

  def update
    @report = Report.find(params[:report]).update_attributes(report_params)
  end

  def report_params
    params.require(:report).permit(:name, :phone, :lat, :long, :status, :description)
  end
end
