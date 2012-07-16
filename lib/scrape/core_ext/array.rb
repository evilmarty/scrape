class Array
  def extract_options!
    last.instance_of?(Hash) ? pop : {}
  end unless instance_methods.include?(:extract_options!)
end