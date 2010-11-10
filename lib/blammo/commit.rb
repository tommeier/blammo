module Blammo
  # A commit represents a commit for a release in the changelog.
  class Commit
    # Matches a commit message with a tag prefix.
    # e.g. [FOO] bar
    MESSAGE_RE = /^(\[\w+\]) (.*)/

    # The supported tags and their possible representations.
    TAGS_RE_MAP = {
      :added   => /(ADDED|NEW)/,
      :changed => /(CHANGED)/,
      :fixed   => /(FIXED)/,
    }

    attr_reader :sha, :message, :tag

    def initialize(sha, message)
      @sha = sha

      if message && message.match(Commit::MESSAGE_RE)
        @tag, @message = Commit.parse_tag($1), $2
      end
    end

    def valid?
      @message.present? && @tag.present?
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
