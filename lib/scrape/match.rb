class Scrape::Match
  attr_reader :matcher

  def initialize matcher, &proc
    @matcher, @proc = matcher, proc
    raise ArgumentError.new("Match block expects one argument") if proc.arity != 1
  end

  def invoke doc
    @proc.call doc
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