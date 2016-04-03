class AddOnDutyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :on_duty, :boolean, :default => false
  end
end
