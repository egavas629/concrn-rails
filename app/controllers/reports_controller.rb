class ReportsController < ApplicationController
  def index
    @reports = Report.all
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
    @report = Report.find(params[:id])
    @report.update_attributes(report_params)


    @report.attach! unless @report.attached?
  end


  def report_params
    params.require(:report).permit(:name, :phone, :lat, :long, :status, :description)
  end
end
