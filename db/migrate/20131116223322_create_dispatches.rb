class CreateDispatches < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.belongs_to :report, index: true
      t.belongs_to :responder, index: true

      t.timestamps
    end
  end
end
