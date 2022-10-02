source 'https://rubygems.org'

gem 'rake'
gem 'foodcritic'
gem 'minitest'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf', '~> 1.3.1'
  gem 'test-kitchen', '~> 1.0.0.alpha.5'
  gem 'kitchen-vagrant', '~> 0.9.0'
end
