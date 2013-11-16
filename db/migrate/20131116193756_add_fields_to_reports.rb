class AddFieldsToReports < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.string :name
      t.string :phone
      t.decimal :long, :precision => 10, :scale => 6
      t.decimal :lat , :precision => 10, :scale => 6
      t.string :status
      t.text   :nature
 
    end
  end
end
