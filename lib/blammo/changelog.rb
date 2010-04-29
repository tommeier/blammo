require 'yaml'

module Blammo
  class Changelog
    attr_accessor :releases

    def initialize(path)
      @path      = path.to_fancypath
      @releases  = @path.exists? ? YAML.load_file(@path) : []
    end

    def update
      commits = Git.commits(@path.dir, last_sha)

      unless commits.empty?
        release = Time.now.strftime("%Y%m%d%H%M%S")
        releases.unshift(release => commits)
      end

      @releases.to_yaml(open(@path, "w"))
    end

    def last_sha
      return if @releases.empty?
      release = @releases.first
      commits = release.first.last
      commit  = commits.detect {|commit| commit.is_a?(Hash)}
      commit ? commit.first.first : nil
    end
  end
end
