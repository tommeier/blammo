module Blammo
  class Commit
    # e.g. [FOO] bar
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

    def to_s
      @message
    end

    def to_yaml(options = {})
      message = "[#{@tag.to_s.upcase}] #{@message}"

      if @sha
        {@sha => message}
      else
        message
      end.to_yaml(options)
    end

    def self.parse_tag(value)
      tag, regexp = TAGS_RE_MAP.detect {|tag, regexp| value =~ regexp }
      tag
    end
  end
end
