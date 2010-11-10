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

    def initialize(path = nil)
      releases  = File.exists?(path) ? YAML.load_file(path) : []
      @releases = Changelog.parse_releases(releases)
    end

    # Updates the changelog from the git repository in the given directory.
    def update(dir, name = nil)
      since   = Changelog.last_sha(@releases)
      release = Release.new(name)
      release.update(dir, since)
      add_release(release)
    end

    def add_release(release)
      @releases.unshift(release) unless release.empty?
    end

    def to_yaml(options = {})
      @releases.to_yaml(options)
    end

    def self.last_sha(releases)
      commit = nil

      releases.each do |release|
        commit = release.commits.detect {|commit| commit.sha }
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
