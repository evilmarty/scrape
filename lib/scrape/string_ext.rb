class String
  def starts_with str
    str = str.to_str
    self[0, str.length] == str
  end unless instance_methods.include?(:starts_with)
end