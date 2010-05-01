require 'git'

module Blammo
  class Release < Struct.new(:name, :commits)
    def to_yaml(options = {})
      {name => commits}.to_yaml(options)
    end

    def to_s
      name
    end
  end

  class Commit < Struct.new(:sha, :message)
    def to_yaml(options = {})
      if sha
        {sha => message}
      else
        message
      end.to_yaml(options)
    end

    def to_s
      message
    end
  end

  class Git
    CHUNK_SIZE = 10

    # Returns all commits in the given path since the given SHA.
    def self.commits(path, last_sha = nil)
      git = ::Git.open(path)
      log = ::Git::Log.new(git, CHUNK_SIZE)

      log.between(last_sha, "head") if last_sha

      [].tap do |commits|
        each_commit(log) do |commit|
          commits << Commit.new(commit.sha, commit.message)
        end
      end
    end

    def self.each_commit(log, &block)
      chunk = 0

      begin
        log.skip(chunk * CHUNK_SIZE)
        log.each {|commit| yield commit}
        chunk += 1
      end until log.size == 0
    end
  end
end
