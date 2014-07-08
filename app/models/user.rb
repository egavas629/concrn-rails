class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :agency

  # VALIDATIONS #
  validates :phone,  presence: true, uniqueness: true
  validates :name,   presence: true, uniqueness: { scope: :agency_id }
  validates :agency, presence: true
end
