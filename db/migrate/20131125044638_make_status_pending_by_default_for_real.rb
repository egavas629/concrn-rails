class MakeStatusPendingByDefaultForReal < ActiveRecord::Migration
  def change
    change_column :reports, :status, :string, :default => "pending"
  end
end
