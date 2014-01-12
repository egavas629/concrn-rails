class Log < ActiveRecord::Base
  default_scope -> { order :created_at }

  belongs_to :report
  belongs_to :author, class_name: 'User'

  def broadcast
    touch(:updated_at) if Message.send(body, to: report.responder.phone)
  end

  def broadcasted?
    created_at != updated_at
  end
end
