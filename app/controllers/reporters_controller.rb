class ReportersController < DashboardController
  def show
    @reports  = current_agency.reports.where(reporter_params)
    @key_info = params['name'] || params['phone'] || params['address']
    render
  end

  private

  def reporter_params
    params.permit([:name, :phone, :address])
  end
end
