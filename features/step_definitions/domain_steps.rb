Given(/^there is an Agency called '(.*)'$/) do |agency_name|
  FactoryGirl.create :agency, name: agency_name
end

Given(/^there is (\d) unassigned report$/) do |quantity|
  quantity.to_i.times { FactoryGirl.create :report, agency: current_user.agency }
end

Given(/^there are (\d+) available responders$/) do |quantity|
  quantity.to_i.times { FactoryGirl.create :responder, agency: current_user.agency }
end

Given(/^I am not signed in$/) do
  logout
end

Given(/^I am signed in$/) do
  step_away_to { login }
end

Then(/^I should see Reports for Las Vegas$/) do
  within '.reports' do
    expect(page).to have_content 'Las Vegas'
  end
end

Given(/^I have an account with '(.*)' as '(.*)':('.*)$/) do |agency_name, user_email, password|
  agency = Agency.where(name: agency_name).pop
  user = FactoryGirl.create :dispatcher, email: user_email, agency: agency, password: password
end
