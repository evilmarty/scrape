class Scrape::Application
  attr_reader :scrapefile, :loader, :sites, :history, :options

  def initialize scrapefile, options = {}, loader = Scrape::DefaultLoader.new
    @scrapefile = File.expand_path scrapefile
    @loader = loader
    @options = options
    @sites = {}
    @queue = []
    @history = []
  end

  def run
    load_scrapefile

    while url = @queue.shift
      @history << url
      begin
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
      rescue OpenURI::HTTPError => e
        Scrape.logger.info "Error loading #{url}: #{e.message}"
      end
    end
  end

  def reset
    @history = []
    @queue = sites.values.map{|site| site.to_s }
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
      site = Scrape::Site.new site, options
      @sites.update site.to_s => site
      site
    end
  end

  def load_scrapefile
    return if @scrapefile_loaded
    raise Scrape::FileNotFound.new(scrapefile) unless File.exists? scrapefile
    result = loader.load scrapefile
    @sites.update result if result.is_a? Hash
    reset
    @scrapefile_loaded = true
  end
end