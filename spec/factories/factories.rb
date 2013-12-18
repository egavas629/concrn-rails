FactoryGirl.define do
  factory :report do
    name    { Faker::Name.name }
    phone   { '6504242429462' }
    lat     { 37.920556 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    long    { 122.416667 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    address { Faker::Address.street_address }
    age     { "Young Adult" }
    gender  { ["Male", "Female"].sample }
    race    { "Caucasian" }
    nature  { Faker::Company.bs }

    trait(:unassigned) {}
  end

  factory :responder do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    password 'password'

    trait(:jacob) do
     name "Jacob"
     phone '6502481396'
    end
  end

  factory :dispatch do
    association :responder
    association :report

    trait(:accepted) do
      after(:create) {|d| d.reject! }
    end

    trait(:rejected) do
      after(:create) {|d| d.accept! }
    end
  end
end

