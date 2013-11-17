class AddSettingAndObservationsToReports < ActiveRecord::Migration
  def change
      add_column :reports, :setting, :string
      add_column :reports, :observations, :string
  end
end
