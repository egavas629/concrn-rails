require 'cucumber/rails'

ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :transaction

