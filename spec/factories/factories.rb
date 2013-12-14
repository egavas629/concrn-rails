FactoryGirl.define do
  factory :report do

    trait(:unassigned) {}
  end

  factory :responder do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    password 'password'
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

