require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

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
