source "https://rubygems.org"

gem "bundler", "~> 2.6.8"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri ], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "rubocop"
  gem "rubocop-rails"

  gem "guard"
  gem "guard-process"
end

# group :development do
#   # Use console on exceptions pages [https://github.com/rails/web-console]
#   gem "web-console"
# end

gem "mimemagic", github: "mimemagicrb/mimemagic", ref: "01f92d86d15d85cfd0f20dabd025dcbd36a8a60f"

gem "nerdify", "2.3.1", source: "https://eXZzsmyrXCfgshYu1n1n@gem.fury.io/nerdify/"
gem "mongoid_auto_increment"
gem "httparty"
gem "ofx"

group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner-mongoid"
  gem "rspec-rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers", "~> 5.2"
end

gem "sorbet-runtime"
gem "geocoder"
gem "google_places"
gem "roo"
gem "roo-xls"

gem "rqrcode", "~> 2.0"

gem "htmlentities"
gem "nokogiri"
