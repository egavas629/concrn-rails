include ActionDispatch::TestProcess
require 'faker'

FactoryGirl.define do
  factory(:report) do
    name    { Faker::Name.name }
    phone   { '5103874543', '2133733979' }
    lat     { 37.920556 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    long    { 122.416667 + (rand() * (rand() > 0.5 ? -1 : 1)) }
    address { Faker::Address.street_address }

    trait(:accepted) do
      after(:create) { |report| create(:dispatch, :accepted, report: report) }
    end

    trait(:archived) do
      after(:create) { |report| report.update_attributes(status: 'archived') }
    end

    trait(:completed) do
      after(:create) do |report|
        create(:dispatch, :completed, report: report)
        report.update_attributes(status: 'completed')
      end
    end

    trait(:pending) do
      after(:create) { |report| create(:dispatch, report: report) }
    end

    trait(:rejected) do
      after(:create) { |report| create(:dispatch, :rejected, report: report) }
    end

    trait(:image_attached) do
      image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
    end
  end
end
