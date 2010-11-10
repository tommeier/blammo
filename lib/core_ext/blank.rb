class NilClass
  unless method_defined?(:blank?)
    def blank?
      true
    end
  end
end

class String
  unless method_defined?(:blank?)
    def blank?
      empty?
    end
  end
end

class Symbol
  unless method_defined?(:blank?)
    def blank?
      false
    end
  end
end
