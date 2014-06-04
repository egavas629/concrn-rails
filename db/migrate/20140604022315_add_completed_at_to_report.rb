class AddCompletedAtToReport < ActiveRecord::Migration
  def change
    add_column :reports, :completed_at, :datetime
  end
end
