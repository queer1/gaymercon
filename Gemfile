source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'capistrano'
gem 'capistrano-unicorn'

gem "mongoid", "~> 3.0.0"
gem 'mysql2'
gem "redis"
gem "sunspot_rails"
gem "sunspot_solr"

gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'high_voltage'
gem "will_paginate"
gem 'bb-ruby', :git => "git@github.com:agius/bb-ruby.git"
gem 'pony'
gem 'hominid' # mailchimp
gem "paperclip"
gem 'rmagick', :require => "RMagick"
gem 'httparty'
gem 'stringex'
gem "fb_graph"
gem "geoip-c", :require => 'geoip'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem "coalmine"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'less-rails-bootstrap'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :require => 'v8'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
group :development do
  gem "lorem"
  gem "debugger"
  gem "thin"
  gem "guard"
end

gem "rspec-rails", "~> 2.0", :groups => [:development, :test]

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'

  gem 'shoulda-matchers'

  gem 'capybara'        # Browser testing

  gem 'guard-rspec'     # Watches rspec test
  gem 'guard-cucumber'  # Watches cucumber features
  gem 'guard-spork'     # Manages Spork for guard

  gem 'rb-fsevent'      # Watches the file system for changes for Guard

  gem 'spork-rails'     # Enables spork for RSpec and Cucumber

  gem 'growl'           # System notifications for guard

  gem 'factory_girl_rails'  # Use factories instead of fixtures
  gem 'factory_girl_rspec', :git => "git@github.com:chendrix/factory_girl_rspec"

  gem 'faker'           # Generate fake data for tests

  gem 'capybara-screenshot'
end
