FactoryGirl.define do
  factory :dispatcher do
    email         { Faker::Internet.email }
    phone         { '6504242429462' }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { 'unavailable' }
    agency
  end

  factory :responder do
    email         { Faker::Internet.email }
    phone         { '6504242429462' }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { 'available' }
    agency

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end
  end
end
