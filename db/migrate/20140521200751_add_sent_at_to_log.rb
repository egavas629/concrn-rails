class AddSentAtToLog < ActiveRecord::Migration
  def change
    add_column :logs, :sent_at, :datetime
  end
end
