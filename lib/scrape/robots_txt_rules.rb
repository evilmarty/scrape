class Scrape::RobotsTxtRules
  def initialize *rules
    @rules = rules.flatten
  end

  def << rule
    @rules.push *Array(rule).flatten
    self
  end

  def + ary
    dup << ary.to_ary
  end

  def =~ str
    str = str.to_str
    @rules.any?{|rule| str.starts_with rule }
  end

  def to_a
    @rules.dup
  end
  alias_method :to_ary, :to_a
end