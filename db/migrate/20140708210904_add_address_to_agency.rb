class AddAddressToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :address, :text
    add_column :agencies, :call_phone, :string
    add_column :agencies, :text_phone, :string
  end
end
