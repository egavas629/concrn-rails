class PhoneNumber < ActiveRecord::Base
  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end
end
