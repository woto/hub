# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test, :staging do
  gem 'dotenv-rails'
  gem 'faker'
  gem 'seedbank'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'pry-byebug'

  gem 'action-cable-testing'
  gem 'awesome_print'
  gem 'bullet'
  #   gem 'bundler-audit'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rswag'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', require: false
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '>= 2.15'
  # gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  # gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'aasm'
gem 'fast_jsonapi'
gem 'kaminari'
gem 'nokogiri'
gem 'numbers_and_words'
gem 'paper_trail'
gem 'rack-attack'
gem 'rails-i18n'
gem 'redis'
gem 'request_store'
gem 'rpush'
gem 'sidekiq'
gem 'typhoeus'

# Elasticsearch family
# gem 'elasticsearch'
# gem 'elasticsearch-transport'
# gem 'elasticsearch-api'
# gem 'elasticsearch-model'
gem 'elasticsearch-persistence'
gem 'elasticsearch-rails'
gem 'elasticsearch-ruby'

# Authorization
gem 'devise'
gem 'devise-i18n'
gem 'devise-security'
gem 'doorkeeper'

# Authentication
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-instagram'
gem 'omniauth-twitter'
gem 'pundit'

# Application monitoring
gem 'newrelic_rpm'
gem 'prometheus-client'
gem 'prometheus_exporter'
gem 'sentry-raven'
gem 'sidekiq-prometheus-exporter', '~> 0.1'

# Dry family
gem 'dry-struct'
gem 'dry-transaction'
gem 'dry-validation'
