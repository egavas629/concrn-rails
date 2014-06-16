class AddAcceptedAtToDispatch < ActiveRecord::Migration
  def change
    add_column :dispatches, :accepted_at, :datetime
  end
end
