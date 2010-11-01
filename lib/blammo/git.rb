require 'git'

module Blammo
  class Git
    CHUNK_SIZE = 10

    # Yield each commit in the given repository since the given SHA.
    def self.each_commit(path, since = nil, &block)
      git   = ::Git.open(path)
      log   = ::Git::Log.new(git, CHUNK_SIZE)
      chunk = 0

      log.between(since, "head") if since

      begin
        log.skip(chunk * CHUNK_SIZE)
        log.each {|commit| block.call(commit.sha, commit.message.strip) }
        chunk += 1
      end until log.size == 0
    end
  end
end
