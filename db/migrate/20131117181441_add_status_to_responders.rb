class AddStatusToResponders < ActiveRecord::Migration
  def change
    add_column :users, :availability, :string, default: "unavailable"
  end
end
