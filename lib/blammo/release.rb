module Blammo
  class Release
    attr_reader :name, :commits

    def initialize(name, commits = [])
      @name    = name
      @commits = commits
    end

    def add_commit(commit)
      @commits << commit
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
        commits = @commits.select {|commit| commit.tag == tag}
      else
        commits = @commits
      end

      commits.each {|commit| block.call(commit)}
    end
  end
end
