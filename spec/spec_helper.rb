$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'blammo/alone'
require 'rr'
require 'rspec'
require 'timecop'

RSpec.configure do |config|
  config.mock_with :rr
end

# FIXME: This is a workaround to get RSpec 2 to play nicely with RR.
require 'rr/adapters/rspec'
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
