class MakeAgencyIdMandatoryForReports < ActiveRecord::Migration
  def change
    add_column :reports, :agency_id, :int, null: false, default: 1
  end
end
