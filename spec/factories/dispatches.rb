FactoryGirl.define do
  factory :dispatch do
    association :responder, :on_shift
    association :report

    trait(:accepted) do
      after(:create) {|d| d.reject! }
    end

    trait(:rejected) do
      after(:create) {|d| d.accept! }
    end
  end
end
