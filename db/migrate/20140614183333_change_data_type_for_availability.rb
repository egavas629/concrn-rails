class ChangeDataTypeForAvailability < ActiveRecord::Migration
  def change
    add_column :users, :availability_tmp, :boolean, default: false
    User.reset_column_information
    Responder.where(availability: 'available').update_all(availability_tmp: true)
    remove_column :users, :availability
    rename_column :users, :availability_tmp, :availability
  end
end
