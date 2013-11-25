class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  before_filter :ensure_dispatcher, only: %w(index active history)

  def ensure_dispatcher
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
  end

  def index
    @unassigned_reports = Report.unassigned
    @pending_reports = Report.pending
  end

  def active
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
    @reports = Report.accepted
  end

  def history
    @reports = Report.completed
  end

  def deleted
    @reports = Report.deleted
  end

  def create
    begin
      @report = Report.create(report_params)
      if @report.save
        Pusher.trigger("reports" , "refresh", {})
        render json: @report
      else
        render json: @report
      end
    rescue Exception => e
      Rails.logger.error e.message
      e.backtrace.each do |b|
        Rails.logger.error b
      end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.status = "deleted"
    @report.save
    redirect_to action: 'history'
  end

  def update
    @report = Report.find(params[:id]).update_attributes(report_params)
    Pusher.trigger("reports" , "refresh", {})
    render json: {success: true}
  end

  def historify
    @report = Report.find(params[:id]).update_attributes(status: "completed")
    redirect_to action: 'index'
  end


  def show
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:name, :phone, :lat, :long, :status, :nature, 
      :setting, :observations, :age, :gender, :race, :address, :neighborhood)
  end
end
