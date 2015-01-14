source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'pg'
# gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'haml'
gem 'simple_form'
gem 'devise'

# Telephony API
gem 'twilio-ruby'

# Pusher API
gem 'pusher'

# Get Coordinates for Address
gem 'geocoder'

# Find time zones by zip code
gem 'tzip'

# Images on AWS S3
gem 'aws-sdk'

# Image uploading
gem 'paperclip'

# Pagination
gem 'kaminari'

# Seed/Testing #since seed of db uses faker need to include
gem 'factory_girl_rails'
gem 'faker'

# Need it in development so creates specs in future scaffolds/generators
gem 'rspec-rails', '~> 2.14.1', group: %w(development test)

# Environment Variable Handling
gem 'figaro'

# Web Server
gem 'thin'

# Assets
gem 'bootstrap-sass-rails'
gem 'bourbon'
gem 'coffee-rails', '~> 4.0.0'
gem 'gritter'
gem 'jquery-rails'
# gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

group :rangers, :production, :staging do
  gem 'rails_12factor'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'simplecov', '~> 0.7.1', :require => false
  gem 'shoulda-matchers', require: false
  gem 'test_after_commit'
end

group :development do
	gem 'guard-rubocop'
	gem 'byebug'
end