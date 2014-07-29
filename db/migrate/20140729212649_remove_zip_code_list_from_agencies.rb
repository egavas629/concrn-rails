class RemoveZipCodeListFromAgencies < ActiveRecord::Migration
  def change
    remove_column :agencies, :zip_code_list, :text
  end
end
