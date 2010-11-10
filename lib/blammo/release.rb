module Blammo
  # A release is a collection of commits in the changelog.
  #
  # When you tell blammo to update, it creates a new release with the most
  # recent commits.
  class Release
    attr_reader :name, :commits

    def initialize(name = nil, commits = [])
      name = Time.now.strftime("%Y%m%d%H%M%S") if name.blank?

      @name    = name
      @commits = commits
    end

    def update(dir, since)
      Git.each_commit(dir, since) do |sha, message|
        commit = Commit.new(sha, message)
        add_commit(commit)
      end
    end

    def add_commit(commit)
      @commits << commit if commit.valid?
    end

    def empty?
      @commits.empty?
    end

    def to_s
      @name
    end

    def to_yaml(options = {})
      {@name => @commits}.to_yaml(options)
    end

    def each_commit(tag = nil, &block)
      if tag
        tag     = tag.to_sym
        commits = @commits.select {|commit| commit.tag == tag }
      else
        commits = @commits
      end

      commits.each {|commit| block.call(commit) }
    end
  end
end
