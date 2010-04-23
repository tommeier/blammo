rc = "#{ENV['HOME']}/.rubyrc"
load(rc) if File.exist?(rc)

ENV['BUNDLE_GEMFILE'] ||= File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'Gemfile')

begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require 'rubygems'
  require 'bundler'

  Bundler.setup
end

envs = [:default]
envs << ENV['BLAMMO_ENV'].downcase.to_sym if ENV['BLAMMO_ENV']
Bundler.require *envs

path = File.join(File.expand_path(File.dirname(__FILE__)), '..')
$:.unshift path

require 'blammo'
