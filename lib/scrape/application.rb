class Scrape::Application
  attr_reader :scrapefile, :loader, :sites, :history, :options

  def initialize scrapefile, options = {}, loader = Scrape::DefaultLoader
    @scrapefile = File.expand_path scrapefile
    @options = options.dup
    @loader = loader.class == Class ? loader.new(self) : loader
    @sites = {}
    reset
  end

  def run
    load_scrapefile

    @queue = sites.values.map{|site| site.to_s } if @queue.empty?

    while url = @queue.shift
      @history << url
      if site = self[url]
        if urls = site.parse(url)
          enqueue *urls
          Scrape.logger.info "Parsed #{url}, found #{urls.length} urls."
        else
          Scrape.logger.info "Parsed #{url}."
        end
      else
        Scrape.logger.info "No rules defined for #{url}"
      end
    end
  end

  def reset
    @history = []
    @queue = []
  end

  def queue
    @queue.dup
  end

  def enqueue *urls
    urls.flatten.each do |url|
      @queue << url unless @history.include?(url) || @queue.include?(url)
    end
  end

  def [] url
    @sites.values.detect{|site| site.accept? url }
  end

  def add_site site, options = {}
    case site
    when String
      site = Scrape::Site.new site, options.dup
      @sites.update site.to_s => site
      site
    end
  end

  def load_scrapefile
    return if @scrapefile_loaded
    loader.load(scrapefile)
    @scrapefile_loaded = true
  end
end