class String
  # Play nice with Rails.
  unless method_defined?(:blank?)
    def blank?
      empty?
    end
  end
end

class NilClass
  # Play nice with Rails.
  unless method_defined?(:blank?)
    def blank?
      true
    end
  end
end
