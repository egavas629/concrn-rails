class RemoveAgencies < ActiveRecord::Migration
  def change
    remove_index :reports, name: 'index_reports_on_agency_id'
    remove_index :users, name: 'index_users_on_agency_id'
    remove_column :reports, :agency_id
    remove_column :users, :agency_id
    drop_table :agencies
  end
end
