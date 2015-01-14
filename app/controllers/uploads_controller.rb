class UploadsController < DashboardController
  before_action :authenticate_dispatcher!

  def destroy
    upload = Upload.find(params[:id])
    upload.destroy!
    respond_to do |format|
      format.js { render json: {success: true} }
      format.html { redirect_to :back }
    end
  end
end
