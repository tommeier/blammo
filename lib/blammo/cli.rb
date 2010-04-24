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

      last_sha = find_last_sha(releases)
      commits  = Git.commits(repo_path, last_sha)

      unless commits.empty?
        release  = Time.now.strftime("%Y%m%d%H%M%S")

        releases.unshift(release => commits)
        releases.to_yaml(open(changelog_path, "w"))
      end

      puts releases.to_yaml
    end

    desc "render PATH", "Renders the given changelog.yml file"
    def render(path)
      releases = YAML.load_file(path)

      releases.each do |release_hash|
        release, groups = release_hash.first
        puts release

        groups.each do |group_hash|
          group, commits = group_hash
          puts "  " + group

          commits.each do |commit_hash|
            sha, message = commit_hash.first
            puts "    " + message
          end
        end
      end

      template = Tilt.new(File.expand_path("../../templates/changelog.markdown.erb", __FILE__))
      puts template.render(nil, :date => Date.today)
    end

    private
      def find_last_sha(releases)
        # TODO: don't use magic!
        releases.first.first.last.first.first.first
      end
  end
end
