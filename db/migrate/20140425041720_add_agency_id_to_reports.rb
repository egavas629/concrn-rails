class AddAgencyIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :agency_id, :int
  end
end
