# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_number do
    phone_number "MyString"
    pin "MyString"
    verified false
  end
end
