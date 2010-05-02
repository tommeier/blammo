module Blammo
  class Commit
    COMMIT_RE = /^(\[\w+\]) (.*)/

    TAGS_RE_MAP = {
      :added   => /(ADDED|NEW)/,
      :changed => /(CHANGED)/,
      :fixed   => /(FIXED)/,
    }

    attr_reader :sha, :message, :tag

    def initialize(sha, message)
      @sha = sha

      if message && message.match(Commit::COMMIT_RE)
        @tag, @message = Commit.parse_tag($1), $2
      end
    end

    def to_yaml(options = {})
      message = "[#{@tag.to_s.upcase}] #{@message}"

      if @sha
        {@sha => message}
      else
        message
      end.to_yaml(options)
    end

    def to_s
      @message
    end

    def self.parse_tag(tag)
      TAGS_RE_MAP.detect {|_, r| tag =~ r}.first
    end
  end
end
