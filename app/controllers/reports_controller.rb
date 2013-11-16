class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
    @dispatched_reports = Report.joins(:dispatch).order("created_at desc")
    @pending_reports = Report.joins("left join dispatches d on d.report_id = reports.id").where("d.id is null").order("created_at desc")
  end

  def create
    @report = Report.create(report_params)
    if @report.save
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
