source 'https://rubygems.org'
ruby '2.3.2'

gem 'google_places'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'rails', '>= 4.1.0' , '< 4.2.0'
gem 'pg'
gem 'jbuilder', '~> 1.2'
gem 'haml'
gem 'simple_form'
gem 'devise', '3.5.4'
# Telephony API
gem 'twilio-ruby', '~> 4.1.0'
gem 'rack-cors', :require => 'rack/cors'
# Pusher API
gem 'pusher'
gem 'geocoder'
gem 'tzip'
gem 'aws-sdk'
gem 'paperclip'
gem 'kaminari'
gem 'factory_girl_rails'
gem 'faker'
gem 'rspec-rails', '~> 2.14.1', group: %w(development test)
gem 'figaro'
gem 'thin'
gem 'bootstrap-sass-rails'
gem 'bourbon'
gem 'coffee-rails', '~> 4.0.0'
gem 'gritter'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'httparty'
gem 'awesome_print'
gem 'by_star'
gem 'pg_search'

group :rangers, :production, :staging do
  gem 'rails_12factor'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'simplecov', '~> 0.7.1', :require => false
  gem 'shoulda-matchers', require: false
  gem 'test_after_commit'
  gem 'webmock'
end

group :development do
	gem 'guard-rubocop'
	gem 'byebug'
  gem 'travis'
  gem 'quiet_assets'
end
