class AddZipCodeListToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :zip_codes_list, :text
  end
end
