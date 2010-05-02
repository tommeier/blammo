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

    def to_yaml(options = {})
      {@name => @commits}.to_yaml(options)
    end

    def to_s
      @name
    end

    def each_commit(tag = nil, &block)
      tag = tag.to_sym
      commits = @commits.select {|commit| commit.tag == tag} if tag
      commits.each {|commit| block.call(commit)}
    end
  end
end
