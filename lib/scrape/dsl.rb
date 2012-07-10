module Scrape::DSL
  def site *urls
    @_sites ||= {}
    @sites ||= {}
    @current_sites = urls.flatten.map{|url| @_sites[url] ||= Scrape::Site.new(url) }
  end

  def match matcher, &proc
    raise ArgumentError.new("site must be set") unless defined? @current_sites
    matches = @current_sites.map{|site| @sites[site.url.to_s] = site; site.add_match matcher, &proc }
    matches.size == 1 ? matches.first : matches
  end
end