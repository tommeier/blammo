require 'git'

module Blammo
  class Git
    CHUNK_SIZE = 10

    # Returns all commits in the given path since the given SHA.
    def self.commits(path, last_sha = nil)
      git = ::Git.open(path)
      log = ::Git::Log.new(git, CHUNK_SIZE)

      log.between(last_sha, "head") if last_sha

      [].tap do |commits|
        each_commit(log) do |commit|
          commits << Commit.new(commit.sha, commit.message.strip)
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
