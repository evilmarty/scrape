require "test_helper"

class ApplicationTest < Scrape::TestCase
  SUPPORT_FILES = File.expand_path File.join(File.dirname(__FILE__), '..', 'support')

  test "#load_scrapefile should parse the specified file" do
    filepath = File.join(SUPPORT_FILES, 'test1.scrape')
    app = Scrape::Application.new(filepath)
    assert app.load_scrapefile, "scrape file failed to load"
    assert_equal ["http://example.com"], app.sites.keys
  end

  test "#load_scrapefile should return nil when already loaded" do
    filepath = File.join(SUPPORT_FILES, 'test1.scrape')
    app = Scrape::Application.new(filepath)
    assert app.load_scrapefile, "scrape file failed to load"
    refute app.load_scrapefile, "scrape file should not have loaded again"
  end

  test "#[] should return the site that matches the given url" do
    app = Scrape::Application.new(".")
    site1 = app.add_site "http://example.com"
    app.add_site "http://example.org"
    assert_equal site1, app["http://example.com"]
  end

  test "#[] should return the site that is relative to the given url" do
    app = Scrape::Application.new(".")
    site1 = app.add_site "http://example.com"
    app.add_site "http://example.org"
    assert_equal site1, app["http://example.com/test"]
  end

  test "#[] should return nil when no site matches the given url" do
    app = Scrape::Application.new(".")
    app.add_site "http://example.com"
    app.add_site "http://example.org"
    assert_nil app["http://example.net"]
  end

  # test "#reset should enqueue the sites that have been defined" do
  #   app = Scrape::Application.new(".")
  #   app.add_site "http://example.com"
  #   app.add_site "http://example.org"
  #   app.reset
  #   assert_equal ["http://example.com", "http://example.org"], app.queue
  # end

  test "#run should load the specified file" do
    filepath = File.join(SUPPORT_FILES, 'test1.scrape')
    test_loader = MiniTest::Mock.new
    test_loader.expect :class, Scrape::DefaultLoader
    test_loader.expect :load, nil, [filepath]
    Scrape::Application.new(filepath, {}, test_loader).run
    assert test_loader.verify, "loader did not receive file"
  end

  test "#enqueue should add the given url to the queue" do
    app = Scrape::Application.new(".")
    app.enqueue "http://example.com"
    assert_equal ["http://example.com"], app.queue
  end

  test "#enqueue should not add the given to the queue when it already is added" do
    app = Scrape::Application.new(".")
    3.times{ app.enqueue "http://example.com" }
    assert_equal ["http://example.com"], app.queue
  end

  test "#add_site should add the specied string to the collection" do
    app = Scrape::Application.new(".")
    app.add_site "http://example.com"
    assert app.sites.member?("http://example.com")
  end
end