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
    @unassigned_reports = Report.unassigned
    @pending_reports = Report.pending
  end

  def active
    @reports = Report.accepted
  end

  def history
    @reports = ReportFilter.new(params).query.page(params[:page])
  end

  def deleted
    @reports = Report.deleted
  end

  # Needed to comment out PUSH and json for it to redirect to index
  # Then just moved it to js in case mobile needs it

  def create
    @report = Report.new(report_params)
    respond_to do |format|
      if @report.save
        format.js do
          Pusher.trigger("reports" , "refresh", {})
          render json: @report
        end
        format.html {
          redirect_to action: 'index'
        }
      else
        format.js {render json: @report}
        format.html {render action: :new}
      end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.status = "deleted"
    @report.update_attribute(:status, "deleted")
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

  # To allow photo upload commented below out and all good.

  def update
    @report = Report.find(params[:id])
    # update_params = report_params
    # if update_params[:image]
    #   bytes = Base64.decode64(update_params.delete(:image))
    #   update_params[:image] = StringIO.new(bytes)
    # end
    @report.update_attributes!(report_params)

    Pusher.trigger("reports" , "refresh", {})
    redirect_to :back
  end

  def historify
    Report.find(params[:id]).update_attributes(status: "completed")
    Pusher.trigger("reports" , "refresh", {})
  end


  def show
    @report = Report.find(params[:id])
    @metaphone = Log.new
  end

  def download
    report = Report.find(params[:id])
    file = open(report.image.url)
    send_data file.read, filename:    report.image_file_name,
                         type:        report.image_content_type,
                         disposition: 'attachment',
                         stream:      'true',
                         buffer_size: '4096'
  end

  def report_params
    report_attributes = [:name, :phone, :lat, :long, :status, :nature, :delete_image,
      :setting, :observations, :age, :gender, :race, :address, :neighborhood, :image]

    params.require(:report).permit report_attributes
  end
end
