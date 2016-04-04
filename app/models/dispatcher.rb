class Dispatcher < User
  belongs_to :user, class_name: User, foreign_key: :id
  default_scope -> { where(role: 'dispatcher') }
end
