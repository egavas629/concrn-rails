class CreateReporterLocations < ActiveRecord::Migration
  def change
    create_table :reporter_locations do |t|
      t.references :user
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
