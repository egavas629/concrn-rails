require 'faker'

FactoryGirl.define do
  factory :user do
    email         { "#{name_to_email(name)}@gmail.com" }
    phone         { Faker::PhoneNumber.phone_number }
    password      { 'password' }
    name          { Faker::Name.name }

    factory :dispatcher, class: Dispatcher do
      role { 'dispatcher' }
    end

    factory :responder, class: Responder do
      role   {'responder'}
      active { true }

      trait(:on_shift) do
        after(:create) { |r| create(:shift, responder: r) }
      end
    end

    trait(:jacob) do
      name  { 'Jacob' }
      phone { '6502481396' }
      email { 'jacob@concrn.com' }
    end
  end
end

def name_to_email(name)
  name.downcase.gsub(/[ .]/, '.' => '', ' ' => '.')
end
