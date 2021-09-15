# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# JSON Web Token (JWT) based authentication solution with token refreshing & blacklisting for APIs built on Rails.
gem 'api_guard'
# Makes http fun again! Ain't no party like a httparty, because a httparty don't stop.
gem 'httparty'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Shim to load environment variables from .env into ENV in development
  gem 'dotenv-rails'
  # rspec-rails brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework, Minitest
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter.
  # https://docs.rubocop.org/rubocop/1.21/installation.html
  # A RuboCop extension focused on enforcing Rails best practices and coding conventions.
  gem 'rubocop-rails', require: false
  # RSpec-specific analysis for your projects, as an extension to RuboCop.
  gem 'rubocop-rspec', require: false
end

group :test do
  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 4.0'
  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
