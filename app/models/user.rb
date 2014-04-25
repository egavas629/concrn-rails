class User < ActiveRecord::Base
  belongs_to :agency
  has_many :reports, through: :agency

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
