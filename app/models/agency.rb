class Agency < ActiveRecord::Base
  has_many :users
  has_many :responders
  has_many :reports
end
