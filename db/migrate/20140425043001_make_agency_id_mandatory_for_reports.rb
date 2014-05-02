class MakeAgencyIdMandatoryForReports < ActiveRecord::Migration
  def change
    change_column :reports, :agency_id, :int, null: false, default: 1
  end
end
