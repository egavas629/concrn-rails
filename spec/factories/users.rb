FactoryGirl.define do
  factory :dispatcher do
    email         { Faker::Internet.email }
    phone         { '2133733979' }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { false }
  end

  factory :responder do
    email         { Faker::Internet.email }
    phone         { ['5103874543', '2133733979'].sample }
    password      { 'password' }
    name          { Faker::Name.name }
    availability  { true }

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end
  end
end
