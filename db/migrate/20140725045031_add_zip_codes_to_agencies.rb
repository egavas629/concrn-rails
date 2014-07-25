class AddZipCodesToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :zip_codes, :text
  end
end
