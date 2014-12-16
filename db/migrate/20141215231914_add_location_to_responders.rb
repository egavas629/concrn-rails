class AddLocationToResponders < ActiveRecord::Migration
  def change
    add_column :users, :long, :decimal, precision: 10, scale: 6
    add_column :users, :lat, :decimal, precision: 10, scale: 6
  end
end
