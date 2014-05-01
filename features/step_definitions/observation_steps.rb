Then(/^I see a warning that (.*)$/) do |warning|
  expect(page).to have_content /#{warning}/
end

Then(/^I see a message (.*)$/) do |message|
  expect(page).to have_content /#{warning}/
end
