include ActionDispatch::TestProcess
require 'faker'

FactoryGirl.define do
  factory(:report) do
    name    { Faker::Name.name }
    phone   { '5103874543' }
    lat     { Random.new.rand(37.781190..37.785505) }
    long    { Random.new.rand(-122.420003..-122.411674) }

    # 37.781190 37.785505
    # -122.411674 -122.420003
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
