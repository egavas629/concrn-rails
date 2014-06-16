# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    start_time "2014-06-14 15:19:21"
    end_time "2014-06-14 15:19:21"
    start_via "MyString"
    end_via "MyString"
    user nil
  end
end
