# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'blammo/alone'

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

  s.add_bundler_dependencies

  s.files        = Dir.glob('{bin,lib,templates}/**/*') + %w(LICENSE README.md)
  s.executables  = ['blam']
  s.require_path = 'lib'
end
