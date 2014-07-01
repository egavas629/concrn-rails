include ActionDispatch::TestProcess
require 'faker'

FactoryGirl.define do
  factory(:report) do
    name    { Faker::Name.name }
    phone   { '5103874543' }
    lat     { 37.920556 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    long    { 122.416667 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    address { Faker::Address.street_address }
    age     { ['Youth (0-17)', 'Young Adult (18-34)', 'Adult (35-64)', 'Senior (65+)'].sample }
    gender  { ['Male', 'Female', 'Other'].sample }
    race    { ['Hispanic or Latino', 'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or Pacific Islander', 'White', 'Other/Unknown'].sample }
    setting { ['Public Space', 'Workplace', 'School', 'Home', 'Other'].sample }
    observations { ['At-risk of harm', 'Under the influence', 'Anxious', 'Depressed', 'Aggarvated', 'Threatening'].sample(rand(6)) }
    nature  { Faker::Lorem.sentence }

    trait(:accepted) do
      after(:create) do |report|
        responder = create(:responder, :on_shift)
        report.dispatch!(responder)
        messanger = DispatchMessanger.new(responder)
        messanger.respond('I accept')
      end
    end

    trait(:archived) do
      status { 'archived' }
    end

    trait(:completed) do
      after(:create) do |report|
        joe = create(:responder, :on_shift)
        report.dispatch! joe
        messsanger = DispatchMessanger.new(joe)
        messsanger.respond 'yes'
        messsanger.respond 'I met him, his name is Francis'
        messsanger.respond 'done, took him to Buckley'
      end
    end

    trait(:pending) do
      after(:create) do |report|
        responder = create(:responder, :on_shift)
        report.dispatch!(responder)
      end
    end

    trait(:rejected) do
      after(:create) do |report|
        responder = create(:responder, :on_shift)
        report.dispatch!(responder)
        messanger = DispatchMessanger.new(responder)
        messanger.respond('No')
      end
    end

    trait(:image_attached) do
      image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
    end
  end
end
