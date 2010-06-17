class String
  #Overwrites the command in Rails and causes odd behaviour
  unless method_defined?(:blank?)
    def blank?
      empty?
    end
  end
end

class NilClass
  #Overwrites the command in Rails and causes odd behaviour
  unless method_defined?(:blank?)
    def blank?
      true
    end
  end
end
