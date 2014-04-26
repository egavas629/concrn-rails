FactoryGirl.define do
  factory :log do
    body { Faker::Lorem.sentence }
    association :author, factory: :responder
    association :report, factory: [:report, :assigned]
  end
end
