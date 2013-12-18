class CreateLogsTable < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :body
      t.integer :author_id
      t.integer :report_id
      t.timestamps
    end
  end
end
