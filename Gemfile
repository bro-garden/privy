source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.2', '>= 7.2.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

gem 'grape'

gem 'grape-jbuilder'

gem 'hashie'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'brakeman', '~> 6.2'
  gem 'bundle-audit', '~> 0.1.0'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'mdl', '~> 0.13.0'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # A gem providing "time travel", "time freezing", and "time acceleration"
  # capabilities, making it simple to test time-dependent code
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'

  # RSpec matchers and stubbing for Wisp
  gem 'wisper-rspec'
end

gem 'dockerfile-rails', '>= 1.6', group: :development

gem 'redcarpet', '~> 3.6'

gem 'aws-sdk-s3', '~> 1.160', require: false

gem 'wisper', '~> 3.0'

source 'https://rubygems.pkg.github.com/bro-garden' do
  gem 'bg_cop'
  gem 'discord_engine'
end

# Database based asynchronous priority queue system
gem 'delayed_job_active_record'

gem 'uuid7', '~> 0.2.0'
