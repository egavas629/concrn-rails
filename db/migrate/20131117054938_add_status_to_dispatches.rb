class AddStatusToDispatches < ActiveRecord::Migration
  def change
    add_column :dispatches, :status, :string, default: :pending
  end
end
