$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'blammo/alone'
require 'rr'
require 'spec'
require 'timecop'

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
