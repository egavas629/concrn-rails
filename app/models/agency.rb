class Agency < ActiveRecord::Base
  # RELATIONS #
  has_many :users, dependent: :destroy

  # VALIDATIONS #
  validates :name,       uniqueness: true, presence: true
  validates :address,    uniqueness: true, presence: true
  validates :text_phone, uniqueness: true, presence: true
  validates :call_phone, uniqueness: true, presence: true
end
