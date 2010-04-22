require 'erb'
require 'thor'
require 'tilt'

module Blammo
  class CLI < Thor
    desc "generate", "Generates a changelog.yml file"
    def generate
    end

    desc "render", "Generates a changelog.yml file"
    def render
      template = Tilt.new(File.expand_path("../../templates/changelog.markdown.erb", __FILE__))
      puts template.render(nil, :date => Date.today)
    end
  end
end
