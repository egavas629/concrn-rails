class AddFeedbackToReports < ActiveRecord::Migration
  def change
    add_column :reports, :responder_feedback, :text
  end
end
