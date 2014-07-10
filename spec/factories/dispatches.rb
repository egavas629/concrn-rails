FactoryGirl.define do
  factory :dispatch do
    association :responder, :on_shift
    association :report

    trait(:accepted) do
      after(:create) do |d|
        d.update_attributes(status: 'accepted', accepted_at: Time.now)
      end
    end

    trait(:completed) do
      after(:create) do |d|
        d.update_attributes(status: 'completed', accepted_at: Time.now)
      end
    end

    trait(:rejected) do
      after(:create) do |d|
        d.update_attributes(status: 'rejected')
      end
    end
  end
end
