class RenameShiftResponderIdColumn < ActiveRecord::Migration
  def change
    rename_column :shifts, :responder_id, :user_id
  end
end
