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

    trait(:completed) do

      after(:create) do |report|
        joe = create :responder
        report.dispatch! joe
        joe.respond 'yes'
        joe.respond 'I met him, his name is Francis'
        joe.respond 'He is currently homeless and tripping'
        joe.respond 'done, took him to Buckley'
      end
    end

    trait(:assigned) do
      after(:create) do |report|
        report.dispatch!(create :responder)
        report.current_dispatch.accept!
      end
    end
  end

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

  factory :log do
    body { Faker::Lorem.sentence }
    association :author, factory: :responder
    association :report, factory: [:report, :assigned]
  end
end
