require 'yaml'

module Blammo
  class Changelog
    attr_reader :releases

    def initialize(path)
      releases_hash  = File.exists?(path) ? YAML.load_file(path) : []
      @releases      = Changelog.parse_releases(releases_hash)
    end

    def refresh(dir, name = nil)
      name    ||= Time.now.strftime("%Y%m%d%H%M%S")
      release   = Release.new(name)
      since     = Changelog.last_sha(@releases)

      Git.each_commit(dir, since) do |sha, message|
        if message =~ Commit::COMMIT_RE
          commit = Commit.new(sha, message)
          release.add_commit(commit) if commit.tag
        end
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
