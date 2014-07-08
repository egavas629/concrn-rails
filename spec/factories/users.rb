require 'faker'

FactoryGirl.define do
  factory :dispatcher do
    email         { "#{name.downcase.gsub(/[ .]/, '.' => '', ' ' => '.')}@gmail.com" }
    phone         { Faker::PhoneNumber.phone_number }
    password      { 'password' }
    name          { Faker::Name.name }
  end

  factory :responder do
    email         { "#{name.downcase.gsub(' ','.')}@gmail.com" }
    phone         { Faker::PhoneNumber.phone_number }
    password      { 'password' }
    name          { Faker::Name.name }
    active        { true }

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end

    trait(:on_shift) do
      after(:create) { |r| create(:shift, responder: r) }
    end
  end
end
