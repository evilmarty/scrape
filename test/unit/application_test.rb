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
    site1 = Scrape::Site.new "http://example.com"
    site2 = Scrape::Site.new "http://example.org"
    app = Scrape::Application.new(".")
    app.sites.update site1.to_s => site1, site2.to_s => site2
    assert_equal site1, app["http://example.com"]
  end

  test "#[] should return the site that is relative to the given url" do
    site1 = Scrape::Site.new "http://example.com"
    site2 = Scrape::Site.new "http://example.org"
    app = Scrape::Application.new(".")
    app.sites.update site1.to_s => site1, site2.to_s => site2
    assert_equal site1, app["http://example.com/test"]
  end

  test "#[] should return nil when no site matches the given url" do
    site1 = Scrape::Site.new "http://example.com"
    site2 = Scrape::Site.new "http://example.org"
    app = Scrape::Application.new(".")
    app.sites.update site1.to_s => site1, site2.to_s => site2
    assert_nil app["http://example.net"]
  end

  test "#reset should enqueue the sites that have been defined" do
    site1 = Scrape::Site.new "http://example.com"
    site2 = Scrape::Site.new "http://example.org"
    app = Scrape::Application.new(".")
    app.sites.update site1.to_s => site1, site2.to_s => site2
    app.reset
    assert_equal ["http://example.com", "http://example.org"], app.queue
  end

  test "#run should load the specified file" do
    filepath = File.join(SUPPORT_FILES, 'test1.scrape')
    test_loader = MiniTest::Mock.new
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

  test "#ignore_robots_txt should update #ignore_robots_txt on all sites" do
    site = Scrape::Site.new "http://www.example.com", :ignore_robots_txt => false
    app = Scrape::Application.new(".")
    app.sites.update site.to_s => site
    assert_equal false, site.ignore_robots_txt
    app.ignore_robots_txt = true
    assert_equal true, site.ignore_robots_txt
  end
end