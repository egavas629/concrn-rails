# Need to run first for test coverage
require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Geocoder.configure(:lookup => :test)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 37.7922304,
      'longitude'    => -122.4061408,
      'address'      => "717 California St, San Francisco, CA 94108, USA",
      'state'        => 'San Francisco',
      'state_code'   => 'CA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true
  config.order = "random"
end