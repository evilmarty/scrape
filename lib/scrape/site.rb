require 'uri'
require 'nokogiri'

class Scrape::Site
  attr_reader :url, :matches

  def initialize url
    @url = URI.parse url
    @url.query = nil
    @url.fragment = nil
    @matches = []
  end

  def add_match matcher, &proc
    match = Scrape::Match.new(matcher, &proc)
    @matches << match
    match
  end

  def parse url
    url = normalize url
    doc = Nokogiri::HTML Scrape.open(url)

    @matches.each{|match| match.invoke doc if match =~ url }

    doc.css("a[href]").map{|node| normalize node['href'] }.select{|url| accept? url }
  end

  def accept? url
    url.to_s[0, to_s.length] == to_s
  end

  def normalize url
    case url
    when /^.+:\/\// then url.dup
    when /^\//      then @url.merge(url).to_s
    else @url.merge("#{@url.path}/#{url}").to_s
    end
  end

  def to_s
    url.to_s
  end
end