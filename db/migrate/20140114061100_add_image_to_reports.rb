class AddImageToReports < ActiveRecord::Migration
  def change
    add_attachment :reports, :image
  end
end
