require 'rubygems'
require 'rake'

require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'blammo', 'alone')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "blammo"
    gem.summary = "CHANGELOG from Blammo."
    gem.description = <<-EOS
      Changelog generator.
    EOS
    gem.email = "josh.bassett@gmail.com"
    gem.homepage = "http://github.com/nullobject/blammo"
    gem.authors = ["Josh Bassett"]

    unless defined?(Bundler::Definition)
      require 'bundler'
    end

    bundle = Bundler::Definition.from_gemfile("Gemfile")
    bundle.dependencies.each do |dep|
      if dep.groups.include?(:runtime) || dep.groups.include?(:default) || dep.groups.include?(:production)
        gem.add_dependency(dep.name, dep.requirement.to_s)
      elsif dep.groups.include?(:development) || dep.groups.include?(:test)
        gem.add_development_dependency(dep.name, dep.requirement.to_s)
      end
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc "Launch an IRB session with the environment loaded"
task :console do
  exec("irb -I lib -r blammo/alone")
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec
