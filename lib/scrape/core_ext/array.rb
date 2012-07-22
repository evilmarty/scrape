class Array
  def extract_options!
    last.instance_of?(Hash) ? pop : {}
  end unless Array.respond_to?(:extract_options!)
end