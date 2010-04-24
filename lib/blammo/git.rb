require 'git'

module Blammo
  class Git
    CHUNK_SIZE = 10

    # Returns commits to the repo in the given path since the given SHA.
    def self.commits(path, last_sha = nil)
      commits = []
      git     = ::Git.open(path)
      log     = ::Git::Log.new(git, CHUNK_SIZE)

      log.between(last_sha, "head") if last_sha

      each_commit(log) do |commit|
        commits << {commit.sha => commit.message}
      end

      commits
    end

    private
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
