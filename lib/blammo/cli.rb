require 'erb'
require 'fancypath'
require 'thor'
require 'tilt'
require 'yaml'

module Blammo
  class CLI < Thor
    CHANGELOG_FILE_NAME = "changelog.yml"

    desc "generate [PATH]", "Generates a changelog.yml file"
    def generate(repo_path = ".")
      changelog_path = repo_path.to_fancypath.dir / CHANGELOG_FILE_NAME
      releases = changelog_path.exists? ? YAML.load_file(changelog_path) : []

      last_sha = self.class.find_last_sha(releases)
      commits  = Git.commits(repo_path, last_sha)

      unless commits.empty?
        release = Time.now.strftime("%Y%m%d%H%M%S")
        releases.unshift(release => commits)
        releases.to_yaml(open(changelog_path, "w"))
      end

      puts releases.to_yaml
    end

    desc "render [PATH]", "Renders the given changelog.yml file"
    def render(path = "changelog.yml")
      releases = YAML.load_file(path)
      template_path = __FILE__.to_fancypath.dir / "../../templates/changelog.markdown.erb".to_fancypath
      template = Tilt.new(template_path)
      puts template.render(nil, :releases => releases)
    end

    def self.find_last_sha(releases)
      return if releases.empty?
      release = releases.first
      commits = release.first.last
      commit  = commits.detect {|commit| commit.is_a?(Hash)}
      commit ? commit.first.first : nil
    end
  end
end
