class AddZipToReports < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.string :zip
    end
  end
end
