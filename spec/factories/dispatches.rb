FactoryGirl.define do
  factory :dispatch do
    association :responder, :on_shift
    association :report

    trait(:accepted) do
      status      { 'accepted' }
      accepted_at { Time.now }
    end

    trait(:completed) do
      status      { 'completed' }
      accepted_at { Time.now }
    end

    trait(:rejected) do
      status { 'rejected' }
    end
  end
end
