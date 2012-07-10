require 'nokogiri'

class Scrape::Site
  attr_reader :url, :matches

  def initialize url
    @url = Scrape::URI.new url
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
    url = self.url + url
    doc = Nokogiri::HTML url.open

    @matches.each{|match| match.invoke doc if match =~ url }

    urls = doc.css("a[href]").map do |node|
      href = self.url + node['href']
      self.url < href ? href : nil
    end
    urls.compact
  end
end