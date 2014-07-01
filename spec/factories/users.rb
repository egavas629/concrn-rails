require 'faker'

FactoryGirl.define do
  factory :dispatcher do
    email         { Faker::Internet.email }
    phone         { '2133733979' }
    password      { 'password' }
    name          { Faker::Name.name }
  end

  factory :responder do
    email         { Faker::Internet.email }
    phone         { ['5103874543', '2133733979'].sample }
    password      { 'password' }
    name          { Faker::Name.name }
    active        { true }

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end

    trait(:on_shift) do
      after(:create) { |responder| responder.shifts.start! }
    end
  end
end
