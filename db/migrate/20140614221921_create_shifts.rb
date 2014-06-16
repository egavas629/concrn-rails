class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :start_via
      t.string :end_via
      t.belongs_to :responder, index: true

      t.timestamps
    end
  end
end
