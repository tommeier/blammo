require 'thor'

module Blammo
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "generate [PATH]", %q(Generates a changelog.yml file (short-cut alias: "g"))
    method_options %w(force -f) => :boolean, %w(name -n) => :string
    map "g" => :generate
    def generate(path = "changelog.yml")
      path      = File.expand_path(path, destination_root)
      changelog = Changelog.new(path)
      changelog.refresh(destination_root, options[:name])
      create_file(path, changelog.to_yaml)
    end

    desc "render [PATH]", %q(Renders the given changelog.yml file (short-cut alias: "r"))
    method_options %w(force -f) => :boolean
    map "r" => :render
    def render(path = "changelog.yml")
      @changelog = Changelog.new(path)
      source     = File.expand_path("../../templates/changelog.html.erb", self.class.source_root)
      template(source, "changelog.html")
    end
  end
end
