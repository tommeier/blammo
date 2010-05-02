module Blammo
  class Release < Struct.new(:name, :commits)
    def to_yaml(options = {})
      {name => commits}.to_yaml(options)
    end

    def to_s
      name
    end

    def each_commit(prefix = nil, &block)
      prefix = prefix.to_s.upcase if prefix
      selected_commits = commits.select {|commit| commit.message =~ /^\[#{prefix}\]/} if prefix
      selected_commits.each {|commit| block.call(commit)}
    end
  end
end
