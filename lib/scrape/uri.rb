require 'uri'
require 'open-uri'

class Scrape::URI
  def initialize uri = nil
    @uri = case uri
    when URI then uri.clone
    when NilClass then URI.new
    else URI.parse uri.to_s
    end
  end

  %w[fragment host hostname password path port query scheme user to_s relative? absolute?].each do |method_name|
    class_eval <<-EOT, __FILE__, __LINE__ + 1
      def #{method_name}
        @uri.#{method_name}
      end
    EOT
  end

  %w[fragment host hostname password path port query scheme user].each do |method_name|
    class_eval <<-EOT, __FILE__, __LINE__ + 1
      def #{method_name}= value
        @uri.#{method_name} = value
      end
    EOT
  end

  def + url
    return clone if self == url
    relative = (url.to_s =~ /^(?!.+:\/\/|\/)/)
    uri = self.class.new @uri.merge(url)
    uri.path = "#{@uri.path}#{uri.path}" if relative
    uri
  end

  def < url
    url[0, length] == to_s
  end

  def [] *args
    to_s[*args]
  end

  def == url
    to_s == url.to_s
  end

  def length
    to_s.length
  end
  alias_method :size, :length

  def open headers = {}, &block
    headers = {"User-Agent" => Scrape.user_agent}.merge(headers)
    super(to_s, headers, &block).read
  end
end