require 'addressable/uri'
require 'nokogiri'

class Scrape::Site
  attr_reader :url, :matches, :options

  def initialize url, options = {}
    @url = Addressable::URI.parse url
    @url.query = nil
    @url.fragment = nil
    @options = {:ignore_robots_txt => true}.merge options
    @matches = []
  end

  def add_match matcher, &proc
    match = Scrape::Match.new(matcher, &proc)
    @matches << match
    match
  end

  def open url
    headers = Hash.new
    headers[:cookie] = cookie if options[:cookie]
    Scrape.open url, headers
  end

  def parse url
    url = normalize url
    doc = Nokogiri::HTML open(url)

    @matches.each{|match| match.invoke doc, url if match =~ url }

    doc.css("a[href]").map{|node| normalize node['href'], url }.select{|url| accept? url }
  rescue Scrape::HTTPError => e
    Scrape.logger.info "Error loading #{url}: #{e.message}"
    nil
  end

  def accept? url
    url = normalize url
    url.starts_with(to_s) && !disallowed?(url)
  end

  def normalize url, base_url = self.url
    Addressable::URI.join(base_url, url).to_s
  end

  def robots_txt
    @robots_txt = Scrape::RobotsTxt.load url unless defined? @robots_txt
  end

  def to_s
    url.to_s
  end

private

  def disallowed? url
    !options[:ignore_robots_txt] && robots_txt =~ Addressable::URI.parse(url).path
  end

  def cookie
    cookie = options[:cookie]
    case cookie
    when Hash
      cookie.map{|name, val| "#{encode(name)}=#{encode(val)}" }.join("; ")
    when String
      cookie
    end
  end

  def encode str
    str.to_s.gsub(" ", "%20").gsub(",", "%2C").gsub(";", "%3B")
  end
end