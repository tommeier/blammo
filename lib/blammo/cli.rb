require 'erb'
require 'thor'
require 'tilt'
require 'yaml'

module Blammo
  class CLI < Thor
    desc "generate [PATH]", "Generates a changelog.yml file"
    def generate(path = ".")
      # TODO: find current SHA
      releases = []
      release  = Date.today.strftime("%Y%m%d")
      commits  = Git.commits(path)

      releases << {release => commits}
      #releases.to_yaml(open("changelog.yml", "w"))
      puts releases.to_yaml
    end

    desc "render PATH", "Renders the given changelog.yml file"
    def render(path)
      dates = YAML.load_file(path)

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
  end
end
