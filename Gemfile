source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'kaminari', '0.12.4' # use kaminari for pagination
gem 'devise', '1.4.2' # use devise for authentication

# use MongoDB with the mongoid gem
gem 'mongoid', '~> 2.2.0'
gem 'bson_ext', '~> 1.3'
gem 'SystemTimer', '~> 1.2', :platforms => :ruby_18

group :development do
  gem 'rspec-rails', '2.6.1'
  gem 'mongoid-rspec', '1.4.4'
  gem 'faker', '0.9.5'
end

group :test do
  gem 'rspec-rails', '2.6.1'
  gem 'mongoid-rspec', '1.4.4'
  gem 'webrat', '0.7.3'
  gem 'factory_girl_rails', '1.1.0'
  # add Autotest for easier running
  gem 'autotest', '4.4.6'
  gem 'autotest-rails-pure', '4.1.2'
  # next 2 gems are only needed if running on OS X
  gem 'autotest-fsevent', '0.2.4'
  gem 'autotest-growl', '0.2.9'
end
