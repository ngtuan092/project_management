source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.2.2"

gem "rails", "~> 7.0.5"
gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "bcrypt", "3.1.18"
gem "bootstrap-sass", "3.4.1"
gem "config"
gem "figaro", "~> 1.1", ">= 1.1.1"
gem "sassc-rails", "2.1.2"
gem "rails-i18n"
gem "pagy"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
gem "bootsnap", require: false
gem "dotenv-rails"

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "faker"
  gem "rspec-rails"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "rondo_form", "~> 0.2.3"
