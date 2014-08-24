class Agency < ActiveRecord::Base
  # RELATIONS #
  has_many :users,   dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :responders,  through: :users
  has_many :dispatchers, through: :users

  # VALIDATIONS #
  validates :name,       uniqueness: true, presence: true
  validates :address,    uniqueness: true, presence: true
  validates :text_phone, uniqueness: true, presence: true
  validates :call_phone, uniqueness: true, presence: true
  validates :zip_code_list, uniqueness:true

  def default?
    name == Report::DEFAULT_TEAM_NAME
  end
end
