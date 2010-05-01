require 'yaml'

module Blammo
  class Changelog
    attr_reader :releases

    def initialize(path)
      @path     = path.to_fancypath
      releases  = @path.exists? ? YAML.load_file(@path) : []
      @releases = self.class.parse_releases(releases)
    end

    def update
      commits = Git.commits(@path.dir, self.class.last_sha(@releases))

      unless commits.empty?
        # TODO: allow release name to be specified from CLI.
        release = Time.now.strftime("%Y%m%d%H%M%S")
        releases.unshift(release => commits)
      end

      @releases.to_yaml(open(@path, "w"))
    end

    def self.last_sha(releases)
      commit = nil

      releases.each do |release|
        commit = release.commits.detect {|commit| commit.sha}
        break if commit
      end

      commit ? commit.sha : nil
    end

    def self.parse_releases(releases)
      releases.map do |release|
        name, commits = release.first

        commits = commits.map do |commit|
          sha, message = commit.is_a?(Hash) ? commit.first : [nil, commit]
          Commit.new(sha, message)
        end.compact

        Release.new(name, commits)
      end
    end
  end
end
