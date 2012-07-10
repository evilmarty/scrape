class Scrape::DefaultLoader
  def load path
    path = File.expand_path path
    sites = {}

    sandbox = Sandbox.new sites
    sandbox.instance_eval File.read(path), path

    sites
  end

  class Sandbox
    include Scrape::DSL

    def initialize sites
      @sites = sites
    end
  end
end