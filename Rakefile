$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'blammo/alone'

require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'verify_rcov'

desc "Launch an IRB session with the environment loaded"
task :console do
  exec("irb -I lib -r blammo/alone")
end

RSpec::Core::RakeTask.new

namespace :rcov do
  RSpec::Core::RakeTask.new do |t|
    t.rcov = true
    t.rcov_opts = %w(--exclude gems\/*,spec\/*,features\/*,.bundle\/* --aggregate coverage.data)
  end

  RCov::VerifyTask.new(:verify) do |t|
    # Allow the coverage to exceed the threshold.
    t.require_exact_threshold = false

    t.threshold = 47.46
  end
end

task :default => :spec
