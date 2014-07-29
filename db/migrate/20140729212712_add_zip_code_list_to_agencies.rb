class AddZipCodeListToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :zip_code_list, :text
  end
end
