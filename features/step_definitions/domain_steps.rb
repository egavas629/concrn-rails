
Given(/^there is (\d) unassigned report$/) do |quantity|
  quantity.to_i.times { FactoryGirl.create :report }
end

Given(/^there are (\d+) available responders$/) do |quantity|
  quantity.to_i.times { FactoryGirl.create :responder }
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

Given(/^I have an account with login info as '(.*)':('.*)$/) do |user_email, password|
  user = FactoryGirl.create :dispatcher, email: user_email, password: password
end
