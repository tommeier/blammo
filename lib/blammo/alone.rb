rc = "#{ENV['HOME']}/.rubyrc"
load(rc) if File.exist?(rc)

require 'rubygems'
require 'bundler'

envs = [:default]
envs << ENV['BLAMMO_ENV'].downcase.to_sym if ENV['BLAMMO_ENV']
Bundler.setup(*envs)

path = File.join(File.expand_path(File.dirname(__FILE__)), '..')
$:.unshift(path)

require 'blammo'
