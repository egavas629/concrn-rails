class AddIndexToLogs < ActiveRecord::Migration
  def change
    add_index :logs, :author_id
    add_index :logs, :report_id
  end
end
