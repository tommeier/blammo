class String
  def blank?
    empty?
  end
end

class NilClass
  def blank?
    true
  end
end
