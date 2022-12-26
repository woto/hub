# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem "bootsnap", require: false
gem 'jbuilder'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# gem "stimulus-rails"

gem 'jsbundling-rails'
gem "cssbundling-rails", "~> 1.1"
gem 'sprockets-rails'

# Active Record audit
gem 'logidze'

group :development, :test do
  # Debug
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # gem 'pry'
  # gem 'pry-byebug'

  # Audit
  # Bullet does not support active_record 6.1.0 yet
  # gem 'bullet'
  gem 'bundler-audit'

  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fantaskspec'
  gem 'liquid'
  gem 'rspec-rails'
  gem 'rspec-sqlimit'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
  gem 'shrine'
  gem 'standard'
  gem 'test-prof'
  gem 'webmock'
  gem 'memory_profiler'
  gem 'stackprof'
  # gem 'isolator'
  # gem 'aruba'
  # gem 'awesome_print'
end

group :development do
  # Conflicts with rails 6.1
  # gem 'meta_request'
  gem 'annotate'
  gem 'i18n-debug'
  gem 'listen', '~> 3.3'
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
  # gem 'rack-mini-profiler'
end

group :development, :test do
  # TODO: check answer
  # https://github.com/teamcapybara/capybara/issues/2432
  # https://github.com/teamcapybara/capybara/compare/master...woto:order_independent_compare
  #
  # This needed for order independent compare of query string
  # Also fixes problem with comparing arrays in query string (ex. foo[]=1&foo[]=2)
  # by replacing Addressable with Rack query string parser
  gem 'capybara', github: 'woto/capybara', branch: 'order_independent_compare'
  # gem 'capybara-chromedriver-logger'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

# Application monitoring
gem 'newrelic_rpm'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'yabeda-http_requests'
gem 'yabeda-prometheus'
gem 'yabeda-puma-plugin'
gem 'yabeda-rails'
gem 'yabeda-sidekiq'

# XML processing
gem 'nokogiri'
# gem "ox", "~> 2.13"

# Faraday
gem 'faraday'
gem 'faraday_middleware'
# gem 'faraday-detailed_logger'
# gem 'faraday_curl'

# gem 'aasm'
gem 'dotenv-rails'
gem 'draper'
gem 'interactor'
gem 'rails-erd'
gem 'rails-i18n'
gem 'redis'
gem "kredis"
# gem 'redis-session-store'
gem 'eu_central_bank'
gem 'money'
# gem 'rails_event_store'
gem 'after_commit_everywhere'
# gem 'paper_trail'
# gem 'rack-attack'
# gem 'rpush'
# gem 'typhoeus'
# gem 'piperator'
# gem 'ransack'
gem 'active_interaction'
gem 'i18n-tasks'
gem 'mobility', github: 'shioyama/mobility'
gem 'sitemap_generator'
gem 'spreadsheet'
# gem "bcrypt", "~> 3.1.7"

# Google API
# gem 'google-api-ruby-client'
# gem 'google-apis-core'
# gem 'google-auth-library-ruby'
gem 'google-apis-indexing_v3'
gem 'google-apis-youtube_v3'

# Grape
gem 'grape'
gem 'grape-swagger'
# gem 'grape-entity'
# gem 'grape-swagger'

# Github API
gem 'octokit'

# Sidekiq
gem 'sidekiq'
gem 'sidekiq-scheduler'
# gem 'sidekiq-failures'
gem 'activejob-uniqueness'

# Views
gem 'kaminari'
gem 'redcarpet'
gem 'github-markup'
gem 'commonmarker'
gem 'simple_form'
gem 'view_component'

# Text processing
# gem 'whatlanguage'
gem 'cld'
gem 'diffy'
# gem 'stopwords-filter', require: 'stopwords', github: 'woto/stopwords-filter', branch: 'fix_locales'

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
# gem 'elasticsearch-dsl', github: 'woto/elasticsearch-ruby', branch: 'highlight_for_collapse'
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
gem 'fastimage', '~> 2.2'
gem 'image_processing'
gem 'mini_magick', '~> 4.10'
gem 'ruby-vips'

# Video processing
gem 'streamio-ffmpeg'

# Graph visualization
gem 'ruby-graphviz'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# Experimental
# gem 'wikipedia-client'
gem 'yard'

# Deprecated
gem 'action-cable-testing'
gem 'numbers_and_words'
gem 'rails-controller-testing'

gem 'htmlbeautifier'
