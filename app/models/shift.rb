class Shift < ActiveRecord::Base
  # RELATIONS #
  belongs_to :responder

  # CALLBACKS #
  after_save :refresh_responders

  # VALIDATIONS #
  validates_presence_of :responder, :start_time, :start_via

  # SCOPE #
  default_scope -> { order('start_time DESC') }
  scope :on_shift, -> { where('start_time <= (?) AND end_time IS ?', Time.now, nil) }

  # CLASS METHODS #
  def self.start!(type='web')
    create!(start_time: Time.now, start_via: type)
  end

  def self.end!(type='web')
    first.update_attributes!(end_time: Time.now, end_via: type)
  end

private

  def refresh_responders
    Pusher.trigger('reports', 'refresh', responder)
  end
end
