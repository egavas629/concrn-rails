class AddClientIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :client_id, :integer
  end
end
