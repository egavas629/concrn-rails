# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :agency do
    name "MyString"

    factory :agency_with_reports do
      after(:create) {|instance| create_list(:report, 5, agency: instance) }
    end
  end
end
