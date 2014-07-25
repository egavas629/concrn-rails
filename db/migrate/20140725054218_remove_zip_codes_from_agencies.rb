class RemoveZipCodesFromAgencies < ActiveRecord::Migration
  def change
    remove_column :agencies, :zip_codes, :text
  end
end
