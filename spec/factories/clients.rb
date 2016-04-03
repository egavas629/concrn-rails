require 'faker'

FactoryGirl.define do
  factory :client do
    name { Faker::Name.name }
    age { Client::AGEGROUP.sample }
    gender { Client::GENDER.sample }
    race { Client::ETHNICITY.sample }
  end
end
