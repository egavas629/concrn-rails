class RemoveResponderIdFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :responder_id, :integer
  end
end
