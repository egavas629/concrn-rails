class MakeAgencyIdMandatoryForReports < ActiveRecord::Migration
  def change
    change_column :reports, :agency_id, :int, null: false
  end
end
