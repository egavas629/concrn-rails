class RemoveAvailabilityFromResponder < ActiveRecord::Migration
  def change
    remove_column :users, :availability, :boolean
  end
end
