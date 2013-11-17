class RemoveStatusToDispatches < ActiveRecord::Migration
  def change
    remove_column :dispatches, :status, :string, default: "pending"
  end
end
