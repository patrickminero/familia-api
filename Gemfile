# Gemfile

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Core Rails gems (already there)
gem "rails", "~> 7.1.6"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Authentication & Authorization
gem "devise"
gem "devise-jwt"
gem "pundit"

# API & Security
gem "rack-cors"
gem "rack-attack"

# File Storage
gem "cloudinary"
gem "activestorage-cloudinary-service"

# Serialization
gem "jsonapi-serializer"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "dotenv-rails"
end

group :development do
  gem "bullet" # N+1 query detection
end
