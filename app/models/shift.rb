class Shift < ActiveRecord::Base
  # RELATIONS #
  belongs_to :responder

  # CALLBACKS #
  after_commit :refresh_responders

  # VALIDATIONS #
  validates_presence_of :responder, :start_time, :start_via

  # SCOPE #
  default_scope -> { order('start_time DESC') }
  scope :on, -> { where('start_time <= (?) AND end_time IS ?', Time.now, nil) }

  # CLASS METHODS #
  def self.started?(responder_id=nil)
    query = responder_id ? on.where(responder_id: responder_id) : on
    query.count > 0
  end

  def self.start!(type='web')
    create!(start_time: Time.now, start_via: type)
  end

  def self.end!(type='web')
    first.update_attributes!(end_time: Time.now, end_via: type)
  end

  # INSTANCE METHODS #
  def same_day?
    start_time.to_date == end_time.to_date
  end

private

  def refresh_responders
    Push.refresh
  end
end
