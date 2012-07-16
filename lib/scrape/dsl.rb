class Scrape::DSL
  def initialize app
    @application = app
  end

  def site *urls
    return @sites if urls.empty?
    urls = urls.flatten
    options = urls.extract_options!
    @sites = urls.map{|url| @application.sites[url] || @application.add_site(url, options) }
  end

  def match matcher, &proc
    raise ArgumentError, "No sites have been defined" unless defined? @sites
    matches = @sites.map{|site| site.add_match matcher, &proc }
    matches.size == 1 ? matches.first : matches
  end
end