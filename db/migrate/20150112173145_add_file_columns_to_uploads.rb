class AddFileColumnsToUploads < ActiveRecord::Migration
  def self.up
    add_attachment :uploads, :file
  end

  def self.down
    remove_attachment :uploads, :file
  end
end