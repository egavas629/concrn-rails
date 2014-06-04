class Log < ActiveRecord::Base
  # RELATIONS #
  belongs_to :report
  belongs_to :author, class_name: 'User'

  # SCOPE #
  default_scope -> { order :created_at }

  # INSTANCE METHODS #
  def broadcast
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    puts report.accepted_responders
    message_sent = false

    report.accepted_responders.each do |responder|
      Message.send(body, to: responder.phone) && message_sent = true
    end

    self.touch(:sent_at) if message_sent
  end

  def broadcasted?
    sent_at.present?
  end
end
