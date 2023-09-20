# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'

gem 'active_hash'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise-jwt'
gem 'dry-struct'
gem 'dry-types'
gem 'jbuilder', '~> 2.7'
gem 'rack-cors'

gem 'stripe'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'stripe-ruby-mock', '~> 3.1.0.rc3', require: 'stripe_mock'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.3'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
