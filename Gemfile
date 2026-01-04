# Gemfile

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Core Rails gems (already there)
gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.6"
gem "tzinfo-data", platforms: %i[windows jruby]

# Authentication & Authorization
gem "devise"
gem "devise-jwt"
gem "pundit"

# API & Security
gem "rack-attack"
gem "rack-cors"

# File Storage
gem "activestorage-cloudinary-service"
gem "cloudinary"

# Serialization
gem "jsonapi-serializer"

group :development, :test do
  gem "database_cleaner-active_record"
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers"
end

group :development do
  gem "bullet"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "solargraph", require: false
end
