RSpec.configure do |configuration|
  # So that rspec knows to use the mongoid-rails gem
  configuration.include Mongoid::Matchers
end