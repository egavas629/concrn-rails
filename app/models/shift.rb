class Shift < ActiveRecord::Base
  # RELATIONS #
  belongs_to :user

  # CALLBACKS #
  after_commit :push_reports

  # VALIDATIONS #
  validates_presence_of :user, :start_time, :start_via

  # SCOPE #
  default_scope -> { order('start_time DESC') }
  scope :on,    -> { where('start_time <= (?) AND end_time IS ?', Time.now, nil) }

  # CLASS METHODS #
  def self.started?(user_id = nil)
    query = user_id ? on.where(user_id: user_id) : on
    query.count > 0
  end

  def self.start(type = 'web')
    create(start_time: Time.now, start_via: type)
  end

  def self.end(type = 'web')
    first.update_attributes(end_time: Time.now, end_via: type)
  end

  # INSTANCE METHODS #
  def same_day?
    start_time.to_date == end_time.to_date
  end

  private

  def push_reports
    Push.refresh
  end
end
