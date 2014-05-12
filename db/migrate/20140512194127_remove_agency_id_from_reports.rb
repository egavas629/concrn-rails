class RemoveAgencyIdFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :agency_id
  end
end
