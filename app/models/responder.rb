class Responder < User
  default_scope -> { where(role: 'responder') }
  has_many :reports
end
