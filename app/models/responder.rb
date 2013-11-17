class Responder < User
  default_scope -> { where(role: 'responder') }
  has_many :reports


  def phone=(new_phone)
    write_attribute(:phone, NumberSanitizer.sanitize(new_phone))
  end
end
