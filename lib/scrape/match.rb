class Scrape::Match
  attr_reader :matcher

  def initialize matcher, &proc
    @matcher, @proc = matcher, proc
    raise ArgumentError, "Not enough arguments in block" if proc.arity == 0
  end

  def invoke *args
    args = args[0, @proc.arity] unless @proc.arity == -1
    @proc.call *args
  end

  def =~ url
    case @matcher
    when String
      url.to_s.include? @matcher
    when Regexp
      url.to_s =~ @matcher
    when Proc
      @matcher.call url
    end
  end
end