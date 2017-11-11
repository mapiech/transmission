source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'

gem 'rails', '~> 5.1.1'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'sqlite3'
gem 'puma', '~> 3.7'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-sass-extras'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'
gem 'redis', '~> 3.0'
gem 'redis-rails'
gem 'devise'
gem 'simple'
gem 'simple_form'
gem 'sidekiq'
gem 'pg'
gem 'ruby_ami'
gem 'daemons'
gem 'asterisk-ari-client'
gem 'net-telnet'
gem 'ruby-asterisk'
gem 'safe_parser', require: 'safe_parser'
gem 'draper'
gem 'omniauth-google-oauth2'
gem 'google-api-client', '~> 0.11'
gem 'signet'
gem 'font-awesome-sass'
gem 'airbrake', '~> 6.1'
gem 'mprofi_api_client'
gem 'cocoon'
gem 'babel-transpiler'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

gem 'whenever', :require => false

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


