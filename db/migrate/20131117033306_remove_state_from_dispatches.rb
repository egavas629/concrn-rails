class RemoveStateFromDispatches < ActiveRecord::Migration
  def change
    remove_column :dispatches, :state, :string
  end
end
