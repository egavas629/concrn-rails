class AddAgencyIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :agency_id, :integer
    add_index :reports, :agency_id
  end
end
