require 'thor'
require 'tilt'

module Blammo
  class CLI < Thor
    desc "generate [PATH]", "Generates a changelog.yml file"
    def generate(path = "changelog.yml")
      changelog = Changelog.new(path)
      changelog.update
      puts changelog.releases.to_yaml
    end

    desc "render [PATH]", "Renders the given changelog.yml file"
    def render(path = "changelog.yml")
      changelog     = Changelog.new(path)
      template_path = __FILE__.to_fancypath.dir / "../../templates/changelog.markdown.erb".to_fancypath
      template      = Tilt.new(template_path)
      puts template.render(nil, :changelog => changelog)
    end
  end
end
