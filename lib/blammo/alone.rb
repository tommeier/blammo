rc = "#{ENV['HOME']}/.rubyrc"
load(rc) if File.exist?(rc)

require 'rubygems'
require 'bundler/setup'

path = File.join(File.expand_path(File.dirname(__FILE__)), '..')
$:.unshift(path)

require 'blammo'
