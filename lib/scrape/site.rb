require 'addressable/uri'
require 'nokogiri'

class Scrape::Site
  attr_reader :url, :matches
  attr_accessor :ignore_robots_txt

  def initialize url, options = {}
    @url = Addressable::URI.parse url
    @url.query = nil
    @url.fragment = nil
    @matches = []
    @ignore_robots_txt = options.fetch(:ignore_robots_txt){ true }
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

    doc.css("a[href]").map{|node| normalize node['href'], url }.select{|url| accept? url }
  end

  def accept? url
    url = normalize url
    url.starts_with(to_s) && !disallowed?(url)
  end

  def normalize url, base_url = self.url
    Addressable::URI.join(base_url, url).to_s
  end

  def robots_txt
    @robots_txt ||= Scrape::RobotsTxt.load url
  end

  def ignore_robots_txt?
    !!@ignore_robots_txt
  end

  def to_s
    url.to_s
  end

private

  def disallowed? url
    !ignore_robots_txt? && robots_txt =~ Addressable::URI.parse(url).path
  end
end