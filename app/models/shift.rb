class Shift < ActiveRecord::Base
  belongs_to :responder

  default_scope -> { order('start_time DESC') }

  def self.start!(type='web')
    create!(start_time: Time.now, start_via: type)
  end

  def self.end!(type='web')
    first.update_attributes!(end_time: Time.now, end_via: type)
  end
end
