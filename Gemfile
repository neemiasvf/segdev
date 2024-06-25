# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'dotenv', require: 'dotenv/load'

gem 'active_model_serializers', '~> 0.10.14'
gem 'awesome_print', '~> 1.9', '>= 1.9.2'
gem 'bootsnap', '~> 1.18', '>= 1.18.3', require: false
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'mysql2', '~> 0.5.6'
gem 'puma', '~> 6.4', '>= 6.4.2'
gem 'rails', '~> 7.1', '>= 7.1.3.4'
gem 'shoulda-matchers', '~> 6.2'

group :development, :test do
  gem 'byebug'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-rails'
end

gem 'tzinfo-data', platforms: %i[windows jruby]
