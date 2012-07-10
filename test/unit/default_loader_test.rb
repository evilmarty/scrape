require "test_helper"

class DefaultLoaderTest < Scrape::TestCase
  SUPPORT_FILES = File.expand_path File.join(File.dirname(__FILE__), '..', 'support')

  test "#load should return sites parsed from the specified file" do
    loader = Scrape::DefaultLoader.new
    sites = loader.load File.join(SUPPORT_FILES, "test1.scrape")
    assert_equal ["http://example.com"], sites.keys
    assert_instance_of Scrape::Site, sites.values[0]
  end

  test "#load should return an empty hash when no matches have been defined" do
    loader = Scrape::DefaultLoader.new
    sites = loader.load File.join(SUPPORT_FILES, "test2.scrape")
    assert_equal Hash.new, sites
  end

  test "#load should raise an error when no site is defined" do
    loader = Scrape::DefaultLoader.new
    assert_raises ArgumentError do
      loader.load File.join(SUPPORT_FILES, "test3.scrape")
    end
  end
end