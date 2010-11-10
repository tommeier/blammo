class NilClass
  unless method_defined?(:present?)
    def present?
      !blank?
    end
  end
end

class String
  unless method_defined?(:present?)
    def present?
      !blank?
    end
  end
end

class Symbol
  unless method_defined?(:present?)
    def present?
      !blank?
    end
  end
end
