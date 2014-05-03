class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  before_filter :ensure_dispatcher, only: %w(index active history)

  def ensure_dispatcher
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
  end

  def new
    @blank_report = Report.new
  end

  def index
    @unassigned_reports = current_user.reports.unassigned
    @pending_reports = current_user.reports.pending
  end

  def active
    @reports = current_user.reports.accepted
  end

  def history
    @reports = current_user.agency.reports.where(status: 'completed').page(params[:page])
  end

  def filter
    @reports  = ReportFilter.new(params['filter'], current_user.agency_id).query if params['filter'].present?

    report_id = params[:report][:id] if params[:report]
    @report   = Report.find(report_id) if report_id.present?

    respond_to do |format|
      format.js
    end
  end

  def deleted
    @reports = current_user.reports.deleted
  end

  def create
    @report = Report.new(report_params)
    p current_user.agency
    p current_user.agency
    p current_user.agency
    p current_user.agency
    p current_user.agency
    @report.agency = current_user.agency

    if @report.save
      Pusher.trigger("reports" , "refresh", {})
      @unassigned_reports = current_user.reports.unassigned
      @pending_reports = current_user.reports.pending
      render json: @report
    else
      @unassigned_reports = current_user.reports.unassigned
      @pending_reports = current_user.reports.pending
      render json: @report
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.status = "deleted"
    @report.save
    redirect_to action: 'history'
  end

  def upload
    @report = Report.find(params[:id])
    update_params = report_params
    @report.update_attributes(update_params)
    p "Report#upload", @report.image_file_name
    @report.save

    Pusher.trigger("reports" , "refresh", {})
    render json: {success: true}
  end

  def update
    begin
    @report = Report.find(params[:id])
    update_params = report_params
    if update_params[:image]
      bytes = Base64.decode64(update_params.delete(:image))
      update_params[:image] = StringIO.new(bytes)
    end
    @report.update_attributes!(update_params)

    Pusher.trigger("reports" , "refresh", {})
    render json: {success: true}
    rescue
      binding.pry
    end
  end

  def historify
    Report.find(params[:id]).update_attributes(status: "completed")
    Pusher.trigger("reports" , "refresh", {})
  end


  def show
    @report = Report.find(params[:id])
    @metaphone = Log.new
  end

  def report_params
    report_attributes = [:name, :phone, :lat, :long, :status, :nature,
      :setting, :observations, :age, :gender, :race, :address, :neighborhood, :image]

    params.require(:report).permit report_attributes
  end
end
