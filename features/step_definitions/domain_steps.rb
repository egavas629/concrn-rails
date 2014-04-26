Given(/^there is an Agency called '(.*)'$/) do |agency_name|
  FactoryGirl.create :agency, name: agency_name
end
