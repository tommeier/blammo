require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'blammo', 'alone')

Gem::Specification.new do |s|
  s.name        = "blammo"
  s.version     = Blammo::VERSION
  s.author      = "Josh Bassett"
  s.email       = "josh.bassett@gmail.com"
  s.homepage    = "http://github.com/NZX/billing-model"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_bundler_dependencies

  s.files = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.executables  = ['blammo']
  s.require_path = 'lib'
end

desc "Launch an IRB session with the environment loaded"
task :console do
  exec("irb -I lib -r blammo/alone")
end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :rcov do
  Spec::Rake::SpecTask.new(:all) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end

  RCov::VerifyTask.new(:verify) do |t|
    t.threshold = 47.46
    t.index_html = 'coverage/index.html'
  end
end

task :default => :spec
