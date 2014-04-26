FactoryGirl.define do
  factory :responder do
    email         { Faker::Internet.email }
    phone         { '6504242429462' }
    password 'password'
    name          { Faker::Name.name }
    availability  { 'available' }

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end
  end
end
