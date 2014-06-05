class ChangeDataTypeForObservations < ActiveRecord::Migration
  def change
    change_column :reports, :observations, :text
  end
end
