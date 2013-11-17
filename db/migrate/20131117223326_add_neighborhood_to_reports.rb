class AddNeighborhoodToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :neighborhood, :string
  end
end
