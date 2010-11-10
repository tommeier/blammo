require 'thor'

module Blammo
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "generate [PATH]", %q(Generates a changelog.yml file (short-cut alias: "g"))
    method_options %w(force -f) => false, %w(output -o) => "changelog.html", %w(name -n) => :string
    map "g" => :generate
    def generate
      output_path = File.expand_path(options[:output], destination_root)
      changelog = Changelog.new(output_path)
      changelog.update(destination_root, options[:name])
      create_file(path, changelog.to_yaml)
    end

    desc "render [PATH]", %q(Renders the given changelog.yml file (short-cut alias: "r"))
    method_options %w(force -f) => false, %w(input -i) => "changelog.yml", %w(output -o) => "changelog.html"
    map "r" => :render
    def render
      input_path  = File.expand_path(options[:input],  destination_root)
      output_path = File.expand_path(options[:output], destination_root)
      @changelog  = Changelog.new(input_path)
      source      = File.expand_path("../../templates/changelog.html.erb", self.class.source_root)
      template(source, output_path)
    end
  end
end
