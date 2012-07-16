class Scrape::DefaultLoader
  def initialize app
    @app = app
  end

  def load path
    path = File.expand_path path
    File.exists? path or raise Scrape::FileNotFound, path
    dsl = Scrape::DSL.new @app
    dsl.instance_eval File.read(path), path
  end
end