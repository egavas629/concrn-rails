require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I press '([^\"]*)'$/ do |button|
  click_button(button)
end

When /^I click '([^\"]*)'$/ do |link|
  click_link(link)
end

When /^I fill in '([^\"]*)' with '([^\"]*)'$/ do |field, value|
  fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I fill in '([^\"]*)' for '([^\"]*)'$/ do |value, field|
  fill_in(field.gsub(' ', '_'), :with => value)
end
