class DropContactsTable < ActiveRecord::Migration
  def up
    drop_table :contacts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
