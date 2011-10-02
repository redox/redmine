source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'i18n'
gem 'coderay'
gem 'rake', '0.8.7'
gem 'prototype-rails', :git => 'git://github.com/rails/prototype-rails.git'
gem 'dynamic_form', :git => 'git://github.com/rails/dynamic_form.git'
gem 'rmagick'
gem 'mysql'
gem 'mysql2'
gem 'sqlite3-ruby'
gem 'rubytree', '0.7.0'
gem 'rails_legacy_mapper'
gem 'awesome_nested_set'
gem 'rails_autolink'
gem 'therubyracer'
gem 'sprockets', '2.0.0' # for now, 2.0.1 has some problem resolving stylesheet_path('application')
gem 'railties', '3.1.0' # force it since coffee-rails depends on 3.1.1
gem 'acts-as-taggable-on', '~>2.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.1.0'
  gem 'coffee-rails', '3.1.0'
  gem 'uglifier'
end

group :development do
  gem 'thin'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem 'mynyml-redgreen'
  gem 'rails-dev-tweaks', '~> 0.4.0'
end

group :production do
end

group :test do
  gem 'test-unit'
  gem 'shoulda', :git => 'http://github.com/redox/shoulda', :branch => 'rails3'
  gem 'mocha'
end
