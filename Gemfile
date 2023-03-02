source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rubocop-rails', require: false
gem 'slim-rails'
gem 'devise'
gem 'net-smtp', require: false
gem 'aws-sdk-s3', require: false
gem 'cocoon'
gem 'gon', '~> 6.1'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-github'
gem 'omniauth-telegram'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10.2'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'kaminari'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'elasticsearch-persistence'
gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'pry', '~> 0.13.1'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "letter_opener", group: :development

  # deploy
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'capybara-email'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'selenium-webdriver'

  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 5.0'

  gem 'database_cleaner'
  gem 'elasticsearch-extensions'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
