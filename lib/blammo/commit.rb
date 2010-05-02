module Blammo
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
end
