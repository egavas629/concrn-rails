class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :agency_id, unique: true
  end
end
