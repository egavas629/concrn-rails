class AddResponderIdToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :responder, index: true
  end
end
