require 'yaml'

module Blammo
  class Changelog
    attr_reader :releases

    def initialize(path)
      releases_hash  = File.exists?(path) ? YAML.load_file(path) : []
      @releases      = Changelog.parse_releases(releases_hash)
    end

    def refresh(dir)
      # TODO: allow release name to be specified from CLI.
      name     = Time.now.strftime("%Y%m%d%H%M%S")
      release  = Release.new(name)
      last_sha = Changelog.last_sha(@releases)
      commits  = Git.commits(dir, last_sha)

      # TODO: this should be run as a block within Git.each_commit.
      commits.each do |commit|
        release.add_commit(commit) if commit.tag
      end

      add_release(release)
    end

    def add_release(release)
      @releases.unshift(release) unless release.commits.empty?
    end

    def to_yaml(options = {})
      @releases.to_yaml(options)
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
