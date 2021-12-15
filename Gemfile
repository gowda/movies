# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.0'

RAILS_VERSION = '~> 6.1.0'
gem 'actionmailer', RAILS_VERSION
gem 'actionpack', RAILS_VERSION
gem 'actionview', RAILS_VERSION
gem 'activejob', RAILS_VERSION
gem 'activemodel', RAILS_VERSION
gem 'activerecord', RAILS_VERSION
gem 'activesupport', RAILS_VERSION
gem 'actioncable', RAILS_VERSION
gem 'railties', RAILS_VERSION
gem 'sprockets-rails', '>= 2.0.0'
gem 'bundler', '>= 1.15.0'

gem 'webpacker',
  git: 'https://github.com/rails/webpacker.git',
  ref: 'ce7cdd707f79065d975c2005d14ec821df30e3b1'

gem 'faraday', '~> 1.8.0'

gem 'bootstrap', '~> 5.1.3'
gem 'jquery-rails', '~> 4.4.0'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'jbuilder', '~> 2.7'

gem 'googleauth', '~> 1.1.0'
gem 'google-apis-oauth2_v2', '~> 0.6.0'

gem 'kaminari', '~> 1.2.0'

gem 'sparql', '~> 3.1.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7.0'
  gem 'rubocop', '~> 1.23.0', require: false
  gem 'rubocop-rails', '~> 2.12.0', require: false
  gem 'rubocop-rspec', '~> 2.6.0', require: false
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'rspec-rails', '~> 5.0.0'
end
