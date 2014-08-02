class ReportsController < DashboardController
  before_action :authenticate_user!,       except: %w(new create update)
  before_action :authenticate_dispatcher!, only: %w(index active history)

  before_action :available_responders, only: %w(index active show)
  before_action :find_report,          only: %w(destroy update show download)

  def new
    @report = Report.new
  end

  def index
    @unassigned_reports = current_agency.reports.unassigned
    @pending_reports = current_agency.reports.pending
  end

  def active
    @reports = current_agency.reports.accepted
  end

  def history
    reports = ReportFilter.new(current_agency.id, params).query
    @reports = params[:show_all] ? reports : reports.page(params[:page])
  end

  def create
    @report = Report.new(report_params)
    respond_to do |format|
      if @report.save
        format.js { render json: @report }
        format.html { redirect_to action: :index }
      else
        format.js { render json: @report }
        format.html { render :new }
      end
    end
  end

  def destroy
    @report.destroy!
    redirect_to action: :index
  end

  def update
    @report.update_attributes(report_params)
    respond_to do |format|
      format.js { render json: {success: true} }
      format.html { redirect_to :back }
    end
  end

  def show
    render
  end

  def download
    file = open(report.image.url)
    send_data file.read, filename:    report.image_file_name,
                         type:        report.image_content_type,
                         disposition: 'attachment',
                         stream:      'true',
                         buffer_size: '4096'
  end

  private

  def available_responders
    @available_responders = current_agency.responders.available
  end

  def find_report
    @report = Report.find(params[:id])
    warn "Found report does not match agency" unless current_agency.try(:id) === @report.agency_id
  end

  def report_params
    report_attributes = [
      :name, :phone, :lat, :long, :status, :nature, :delete_image, :setting,
      { observations: [] }, :age, :gender, :race, :address, :neighborhood,
      :image, :agency_id, :urgency
    ]

    params.require(:report).permit report_attributes
  end
end
