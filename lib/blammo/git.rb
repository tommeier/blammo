require 'git'

module Blammo
  class Git
    CHUNK_SIZE = 10

    # Loads commits from the repo in the given path.
    def self.commits(path)
      commits = []
      git     = ::Git.open(path)
      log     = ::Git::Log.new(git, CHUNK_SIZE)

      each_commit(log) do |commit|
        commits << {commit.sha => commit.message}
      end

      commits
    end

    def self.each_commit(log, &block)
      chunk = 0

      begin
        log.skip(chunk * CHUNK_SIZE)
        chunk += 1

        log.each do |commit|
          yield commit
        end
      end until log.size == 0
    end
  end
end
