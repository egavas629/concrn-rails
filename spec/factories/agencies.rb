require 'faker'

FactoryGirl.define do
  factory :agency do
    name       { Faker::Company.name }
    address    { Faker::Address.street_address }
    text_phone { Faker::PhoneNumber.cell_phone }
    call_phone { Faker::PhoneNumber.phone_number }
    zip_code_list { Faker::Address.zip_code }
  end
end
