require 'yaml'

module Blammo
  # A changelog is a collection of releases, stored in reverse-chronoloical
  # order. Every time you create a release for your project, it is added
  # to the changelog.
  #
  # A changelog is stored in a single YAML file. It can be rendered to a
  # variety of different output formats (e.g. HTML, markdown, plain-text,
  # etc).
  class Changelog
    attr_reader :releases

    def initialize(path)
      releases_hash  = File.exists?(path) ? YAML.load_file(path) : []
      @releases      = Changelog.parse_releases(releases_hash)
    end

    # Adds a new release with an optional name containing the commits since the last relese from the git repository in the given directory.
    def refresh(dir, name = nil)
      name    ||= Time.now.strftime("%Y%m%d%H%M%S")
      since     = Changelog.last_sha(@releases)
      release   = Release.new(name)

      Git.each_commit(dir, since) do |sha, message|
        if message =~ Commit::COMMIT_RE
          commit = Commit.new(sha, message)
          release.add_commit(commit) if commit.tag
        end
      end

      add_release(release) unless release.commits.empty?
    end

    def add_release(release)
      @releases.unshift(release)
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
