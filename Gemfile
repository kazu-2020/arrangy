source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'

# database
gem 'pg', '>= 0.18', '< 2.0'
gem 'redis'
gem 'redis-rails'

# seed for database
gem 'seed-fu'

# Use Puma as the app server
gem 'puma', '~> 4.1'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# authentication
gem 'sorcery'

# serializer
gem 'jbuilder', '~> 2.7'
gem 'jsonapi-serializer'

# image uploader
gem 'aws-sdk-s3', '~> 1'

# pagination
gem 'pagy', '~> 3.5'

# I18n
gem 'rails-i18n', '~> 6.0.0'

# Settings Management
gem 'config'

# Slack integration
gem 'slack-notifier'

# sidekiq
gem 'sidekiq'

# SEO plugin
gem 'meta-tags'

# Error monitoring
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sentry-sidekiq'

# Performance Analysis
gem 'newrelic_rpm'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Code check
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'bundler-audit', require: false
  gem 'rails_best_practices', require: false
  gem 'rubocop', '~> 1.10', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec', require: false

  # debug
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'

  # test
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 4.0.2', require: true
  gem 'rspec-retry'
  gem 'spring-commands-rspec'
end

group :development do
  # For email testing
  gem 'letter_opener_web', '~> 1.0'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', require: false
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
