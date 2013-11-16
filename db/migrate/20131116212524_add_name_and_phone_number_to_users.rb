class AddNameAndPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :role, :string, default: "responder"
  end
end
