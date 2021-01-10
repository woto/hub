# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4'
gem 'rails', '~> 6.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
# gem 'turbo-rails', github: 'hotwired/turbo-rails', branch: :main
gem 'turbo-rails'
# gem "stimulus-rails"

group :development, :test do
  # Debug
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'pry-byebug'

  # Audit
  # Bullet does not support active_record 6.1.0 yet
  # gem 'bullet'
  gem 'bundler-audit'

  # Testing
  # https://github.com/DatabaseCleaner/database_cleaner-active_record/pull/39
  gem 'database_cleaner-active_record', github: 'DatabaseCleaner/database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'standard'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'fantaskspec'
  gem 'webmock'
  gem 'test-prof'
  # gem 'isolator'
  # gem 'aruba'
  # gem 'awesome_print'
end

group :development do
  # Conflicts with rails 6.1
  # gem 'meta_request'
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  # gem 'i18n-debug'
end

group :test do
  # gem 'capybara', '>= 2.15'
  # this needed for order independent compare of query string
  # TODO: check answer
  # https://github.com/teamcapybara/capybara/issues/2432
  # https://github.com/teamcapybara/capybara/compare/master...woto:order_independent_compare
  gem 'capybara', github: 'woto/capybara', branch: 'order_independent_compare'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

# Application monitoring
gem 'newrelic_rpm'
gem 'sentry-raven'
gem 'yabeda-rails'
gem 'yabeda-prometheus'
gem 'yabeda-sidekiq'
gem 'yabeda-puma-plugin'

# XML processing
gem 'nokogiri'
# gem "ox", "~> 2.13"

# Faraday
gem 'faraday'
gem 'faraday_middleware'
# gem 'faraday-detailed_logger'
# gem 'faraday_curl'

# gem 'aasm'
gem 'draper'
gem 'dotenv-rails'
gem 'interactor'
gem 'rails-erd'
gem 'rails-i18n'
gem 'redis'
# gem 'redis-session-store'
gem 'money'
gem 'eu_central_bank'
# gem 'rails_event_store'
gem 'after_commit_everywhere'
# gem 'paper_trail'
# gem 'rack-attack'
# gem 'rpush'
# gem 'typhoeus'
# gem 'piperator'
# gem 'ransack'
gem 'spreadsheet'
gem 'mobility', github: 'shioyama/mobility'

# Sidekiq
gem 'sidekiq'
gem 'sidekiq-scheduler'

# Views
gem 'kaminari'
gem 'redcarpet'
gem 'simple_form'
gem 'view_component'

# language detect
# gem 'whatlanguage'
gem 'cld'

# Tree structure
gem 'ancestry', github: 'stefankroes/ancestry'
# gem 'awesome_nested_set'
# gem 'closure_tree'

# Administration
# gem 'activeadmin'
# gem 'administrate'
# gem 'rails_admin'

# Elasticsearch family
gem 'elasticsearch'
gem 'elasticsearch-api'
gem 'elasticsearch-dsl'
gem 'elasticsearch-model'
gem 'elasticsearch-persistence'
gem 'elasticsearch-rails'
gem 'elasticsearch-ruby'
gem 'elasticsearch-transport'
# gem 'elasticsearch-extensions'

# Authentication
gem 'devise'
gem 'devise-i18n'
gem 'devise-security'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-instagram'
gem 'omniauth-twitter'
gem 'pretender'

# Authorization
gem 'pundit'

# Dry family
gem 'dry-struct'
# gem 'dry-transaction'
# gem 'dry-monads'
gem 'dry-validation'

# Image processing
gem 'image_processing', '~> 1.11'
gem 'mini_magick', '~> 4.10'

# Deprecated
gem 'rails-controller-testing'
gem 'numbers_and_words'
gem 'action-cable-testing'
gem 'rack-cors'
