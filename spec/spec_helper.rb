ENV['BLAMMO_ENV'] ||= 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'blammo/alone'
require 'rr'
require 'spec'

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
