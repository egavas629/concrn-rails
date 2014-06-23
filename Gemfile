source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'pg'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'haml'
gem 'simple_form'
gem 'devise'

# Telephony API
gem 'twilio-ruby'

gem 'pusher'
gem 'foreman'

# Get Coordinates for Address
gem 'geocoder'

# Get query info
gem 'bullet', group: :development

# Images on AWS S3
gem 'aws-sdk'

# Image uploading
gem 'paperclip'

# Pagination
gem 'kaminari'

# Seed/Testing
gem 'factory_girl_rails'

# Environment Variable Handling
gem 'figaro'

# Web Server
gem 'thin'

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass-rails'
gem 'jquery-ui-rails'
gem 'bourbon'
gem 'jquery-turbolinks'
gem 'gritter'
gem 'coveralls', require: false

group :production, :staging do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'quiet_assets'
  gem 'faker'
  gem 'jazz_hands'
end

group :test do
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
end
