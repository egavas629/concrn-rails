class Log < ActiveRecord::Base
  belongs_to :report
  belongs_to :author, class_name: 'User'

  def broadcast
    Message.send body, to: report.responder.phone
  end
end
