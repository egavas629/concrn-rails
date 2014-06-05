FactoryGirl.define do
  factory :dispatcher do
    email         { Faker::Internet.email }
    phone         { '5103874543' }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { 'unavailable' }
  end

  factory :responder do
    email         { Faker::Internet.email }
    phone         { ['4242429462', '5103874543'].sample }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { 'available' }

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end
  end
end
