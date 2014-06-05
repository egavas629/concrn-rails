FactoryGirl.define do
  factory(:report) do
    name    { Faker::Name.name }
    phone   { ['4242429462', '5103874543'].sample }
    lat     { 37.920556 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    long    { 122.416667 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    address { Faker::Address.street_address }
    age     { ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)'].sample }
    gender  { ['Male', 'Female', 'Other'].sample }
    race    { ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown'].sample }
    setting { ['Public Space', 'Workplace', 'School', 'Home', 'Other'].sample }
    observations { ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening'].sample(rand(6)) }
    nature  { Faker::Lorem.sentence }

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
        report.dispatches.last.accept!
      end
    end
  end
end
