# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'blammo/version'

Gem::Specification.new do |s|
  s.name        = "blammo"
  s.version     = Blammo::VERSION
  s.author      = "Josh Bassett"
  s.email       = "josh.bassett@gmail.com"
  s.description = "Changelog generator."
  s.summary     = "CHANGELOG from Blammo."
  s.homepage    = "http://github.com/nullobject/blammo"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "blammo"

  s.files        = Dir.glob('{bin,lib,templates}/**/*') + %w(LICENSE README.md)
  s.executables  = ['blam']
  s.require_path = 'lib'

  s.add_dependency 'git',  '~> 1.2.5'
  s.add_dependency 'thor', '~> 0.14.0'

  s.add_development_dependency 'bundler', '~> 1.0.0'
  s.add_development_dependency 'hirb',    '~> 0.3.2'
  s.add_development_dependency 'rake',    '~> 0.8.7'
  s.add_development_dependency 'rcov',    '~> 0.9.8'
  s.add_development_dependency 'rspec',   '~> 2.0.0'
  s.add_development_dependency 'rr',      '~> 1.0.0'
  s.add_development_dependency 'timecop', '~> 0.3.5'
  s.add_development_dependency 'wirble',  '~> 0.1.3'
end
