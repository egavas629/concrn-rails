class AgencyPresenter < BasePresenter
  presents :agency

  def created_at
    agency.created_at.strftime('%-m/%-d/%y')
  end

end
