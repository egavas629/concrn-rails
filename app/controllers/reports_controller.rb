class ReportsController < ApplicationController
  before_action :authenticate_user!,   only: %w(index)
  before_action :ensure_dispatcher,    only: %w(index active history)
  before_action :available_responders, only: %w(index active)
  before_action :find_report,          only: %w(destroy update show download)
  before_action :new_report,           only: %w(new create)

  def new
  end

  def index
    @unassigned_reports = Report.unassigned
    @pending_reports = Report.pending
  end

  def active
    @reports = Report.accepted
  end

  def history
    reports = ReportFilter.new(params).query
    @reports = params[:show_all] ? reports : reports.page(params[:page])
  end

  # Needed to comment out Pusher for it to redirect to index
  def create
    respond_to do |format|
      if @report.save
        format.js { render json: @report }
        format.html { redirect_to action: :index }
        # Pusher.trigger('reports' , 'refresh', {})
      else
        format.js { render json: @report }
        format.html { render action: :new }
      end
    end
  end

  def destroy
    @report.destroy!
    redirect_to action: :index
  end

  # def upload
  #   update_params = report_params
  #   @report.update_attributes(update_params)
  #   p "Report#upload", @report.image_file_name
  #   @report.save
  #
  #   Pusher.trigger("reports" , "refresh", {})
  #   render json: {success: true}
  # end

  def update
    @report.update_attributes!(report_params)
    Pusher.trigger("reports" , "refresh", {})
    respond_to do |format|
      format.js { render json: {success: true} }
      format.html { redirect_to :back }
    end
  end

  def show
    @metaphone = Log.new
  end

  def download
    file = open(report.image.url)
    send_data file.read, filename:    report.image_file_name,
                         type:        report.image_content_type,
                         disposition: 'attachment',
                         stream:      'true',
                         buffer_size: '4096'
  end

  def available_responders
    @available_responders = Responder.available
  end

  private

  def find_report
    @report = Report.find(params[:id])
  end

  def new_report
    @report = Report.new(report_params)
  end

  def ensure_dispatcher
    redirect_to edit_user_registration_path unless current_user.role == 'dispatcher'
  end

  def report_params
    report_attributes = [:name, :phone, :lat, :long, :status, :nature, :delete_image, :setting, {:observations => []}, :age, :gender, :race, :address, :neighborhood, :image]

    params.require(:report).permit report_attributes
  end
end
