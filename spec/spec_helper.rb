require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'shoulda/matchers'
require "paperclip/matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

include FactoryGirl::Syntax::Methods

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Paperclip::Shoulda::Matchers

  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:each) do
    Telephony.stub(:message)
  end
end
