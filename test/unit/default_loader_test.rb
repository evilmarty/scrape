require "test_helper"

class DefaultLoaderTest < Scrape::TestCase
  SUPPORT_FILES = File.expand_path File.join(File.dirname(__FILE__), '..', 'support')

  test "#load should parse the specified file" do
    app = Scrape::Application.new "."
    loader = Scrape::DefaultLoader.new app
    loader.load File.join(SUPPORT_FILES, "test1.scrape")
    assert_equal ["http://example.com"], app.sites.keys
    assert_instance_of Scrape::Site, app.sites.values[0]
  end

  test "#load should raise error when no site is defined" do
    app = Scrape::Application.new "."
    loader = Scrape::DefaultLoader.new app
    assert_raises ArgumentError do
      loader.load File.join(SUPPORT_FILES, "test3.scrape")
    end
  end

  test "#load should raise error when file cannot be found" do
    app = Scrape::Application.new "."
    loader = Scrape::DefaultLoader.new app
    assert_raises Scrape::FileNotFound do
      loader.load "#{Time.now.to_i}.txt"
    end
  end
end