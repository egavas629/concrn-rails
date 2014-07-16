class Log < ActiveRecord::Base
  # RELATIONS #
  belongs_to :report
  belongs_to :author, class_name: 'User'

  delegate :name, :role, to: :author, prefix: true

  # VALIDATIONS #
  validates_presence_of :author, :report, :body

  # CALLBACKS #
  after_commit :refresh_report

  # SCOPE #
  default_scope -> { order(:created_at) }

  # INSTANCE METHODS #
  def broadcast
    message_sent = false

    Responder.accepted(report.id).each do |responder|
      Telephony.send(body, responder.phone) && message_sent = true
    end

    update_attributes(sent_at: Time.now) if message_sent
  end

  def broadcasted?
    sent_at.present?
  end

  private

  def refresh_report
    Push.update_transcript(report.id, self)
  end
end
