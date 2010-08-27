require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

desc "Launch an IRB session with the environment loaded"
task :console do
  exec("irb -I lib -r blammo/alone")
end

Spec::Rake::SpecTask.new(:spec)

namespace :rcov do
  Spec::Rake::SpecTask.new(:spec) do |t|
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
