class AddStateToDispatches < ActiveRecord::Migration
  def change
    add_column :dispatches, :state, :string
  end
end
