FactoryGirl.define do
  factory :dispatch do
    association :responder, :on_shift
    association :report

    trait(:accepted) do
      after(:create) do |d|
        dm = DispatchMessanger.new(d.responder)
        dm.respond('yes')
        d.reload
      end
    end

    trait(:completed) do
      after(:create) do |d|
        dm = DispatchMessanger.new(d.responder)
        dm.respond('yes')
        dm.respond('done')
        d.reload
      end
    end

    trait(:rejected) do
      after(:create) do |d|
        dm = DispatchMessanger.new(d.responder)
        dm.respond('no')
        d.reload
      end
    end
  end
end
