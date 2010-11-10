$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'blammo/alone'

require 'cucumber/formatter/unicode'
require 'cucumber/web/tableish'

require 'capybara/cucumber'

require 'rack'

Capybara.app = Rack::Builder.new do
  map "/" do
    use Rack::Static, :urls => ["/"], :root => "/tmp"
    run lambda {|env| [404, {}, ""]}
  end
end.to_app
