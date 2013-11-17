class RenameResponderFeedbackToFeedback < ActiveRecord::Migration
  def change
    rename_column :reports, :responder_feedback, :feedback
  end
end
