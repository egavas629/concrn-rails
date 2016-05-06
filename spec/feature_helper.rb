require 'shared_helper'
require 'capybara/rspec'

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.before(:suite) { Warden.test_mode! }
  config.after(:each) { Warden.test_reset! }
end
