class AddRejectionReasonToDispatches < ActiveRecord::Migration
  def change
    add_column :dispatches, :rejection_reason, :string
  end
end
