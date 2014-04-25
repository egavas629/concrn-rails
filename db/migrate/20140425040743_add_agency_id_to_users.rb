class AddAgencyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agency_id, :int
  end
end
