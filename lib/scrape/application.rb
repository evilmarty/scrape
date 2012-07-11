class Scrape::Application
  attr_reader :scrapefile, :loader, :sites, :history

  def initialize scrapefile, loader = Scrape::DefaultLoader.new
    @scrapefile = File.expand_path scrapefile
    @loader = loader
    @sites = {}
    @queue = []
    @history = []
  end

  def run
    load_scrapefile

    while url = @queue.shift
      Scrape.logger.info "Loading: #{url}..."
      @history << url
      if site = self[url]
        if urls = site.parse(url)
          enqueue *urls
          Scrape.logger.info "Found #{urls.length} urls."
        else
          Scrape.logger.info "Done."
        end
      else
        Scrape.logger.info "Not defined."
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

  def load_scrapefile
    return if @scrapefile_loaded
    result = loader.load(scrapefile)
    @sites.update result if result.is_a? Hash
    reset
    @scrapefile_loaded = true
  end
end