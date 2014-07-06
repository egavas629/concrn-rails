require 'faker'

FactoryGirl.define do
  factory :log do
    body { Faker::Lorem.sentence }
    association :author, factory: :dispatcher
    association :report, factory: [:report, :accepted]
  end
end
