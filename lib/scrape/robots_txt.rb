require 'addressable/uri'

class Scrape::RobotsTxt
  def initialize rules
    @rules = rules
    @rules.default = Scrape::RobotsTxtRules.new
  end

  def user_agents
    @rules.keys
  end

  def disallows
    @rules.values.flatten
  end

  def [] user_agent
    rules  = @rules[user_agent].clone
    rules += @rules['*'] unless user_agent == '*'
    rules
  end

  def =~ str
    self[Scrape.user_agent] =~ str
  end

  def each &block
    @rules.each &block
  end

  def self.parse content
    rules, user_agent = Hash.new, nil

    content.split("\n").each do |line|
      case line
      when /^#/
        next
      when /User-agent:\s*(.+)/
        user_agent = $1.strip
        rules.update user_agent => Scrape::RobotsTxtRules.new
      when /Disallow:\s*(.+)/
        rules[user_agent] << $1.strip
      end
    end

    new rules
  end

  def self.load url, default = true
    url = Addressable::URI.join(url, "/robots.txt") if default
    parse Scrape.open(url)
  rescue OpenURI::HTTPError
    nil
  end
  public :load
end