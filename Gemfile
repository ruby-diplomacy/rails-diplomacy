source 'http://rubygems.org'

RAILS_VERSION = '~> 3.1.1'
DM_VERSION = '~> 1.2.0'
gem 'activesupport',      RAILS_VERSION, :require => 'active_support'
gem 'actionpack',         RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION, :require => 'action_mailer'
gem 'railties',           RAILS_VERSION, :require => 'rails'
gem 'tzinfo'
gem 'dm-rails'
gem 'dm-sqlite-adapter'
gem 'rails', :require => nil

gem 'dm-migrations',        DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-constraints',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'execjs'

gem 'therubyracer'
gem 'faye'
gem 'less-rails-bootstrap'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
group :development do 
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'watchr'
  gem 'spork'
  gem 'foreman'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'factory_girl'
  gem 'database_cleaner'
  gem 'capybara'
end
