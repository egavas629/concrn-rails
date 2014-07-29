class AddUrgencyToReports < ActiveRecord::Migration
  def change
    add_column :reports, :urgency, :string
  end
end
