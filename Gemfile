# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'activesupport', '~> 6.0'
gem 'carmen', '~> 1.0', '>= 1.0.2'
gem 'faraday', '~> 1.0', '>= 1.0.1'
gem 'faraday_middleware', '~> 1.0'
gem 'hashie', '~> 4.1'
gem 'json', '~> 2.3'

group :development do
  gem 'rubocop'
end

group :development, :test do
  gem 'faraday-detailed_logger', '~> 2.3'
  gem 'minitest', '~> 5.14'
  gem 'rake', '~> 13.0', '>= 13.0.1'
end
