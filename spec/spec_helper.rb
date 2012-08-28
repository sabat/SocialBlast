require 'simplecov'
require 'rspec'
require 'debugger'
require 'twitter'

SimpleCov.start
require 'social_blast'

RSpec.configure do |config|
  config.before(:suite) { $VERBOSE=nil }
end

