class MakeStatusPendingByDefault < ActiveRecord::Migration
  def change
    change_column :reports, :status, :string, :default => true
  end
end
