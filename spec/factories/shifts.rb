FactoryGirl.define do
  factory :shift do
    association   :responder
    start_time  { Time.now - [*1..5].sample.days }
    start_via   { %w(web sms).sample }

    trait(:ended) do
      end_time { Time.now }
      end_via  { %w(web sms).sample }
    end
  end
end
