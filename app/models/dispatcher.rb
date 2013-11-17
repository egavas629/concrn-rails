class Dispatcher < User
  default_scope -> { where(role: 'dispatcher') }
end
