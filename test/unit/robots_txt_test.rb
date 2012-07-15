require "test_helper"

class RobotsTxtTest < Scrape::TestCase
  test "#user_agents should return an array" do
    robots = Scrape::RobotsTxt.new "Test" => []
    assert_equal ["Test"], robots.user_agents
  end

  test "#disallows should return an array" do
    robots = Scrape::RobotsTxt.new "Test" => ["/foo"]
    assert_equal ["/foo"], robots.disallows
  end

  test "#[] should return all disallows for the specified user agent" do
    robots = Scrape::RobotsTxt.new "Test" => ["/foo"]
    assert_equal ["/foo"], robots["Test"]
  end

  test "#[] should return all disallows for the specified user agent including wildcard" do
    robots = Scrape::RobotsTxt.new "Test" => ["/foo"], "*" => ["/bar"]
    assert_equal ["/foo", "/bar"], robots["Test"]
  end

  test "#[] should return all disallows for wildcard" do
    robots = Scrape::RobotsTxt.new "Test" => ["/foo"], "*" => ["/bar"]
    assert_equal ["/bar"], robots["*"]
  end

  test ".parse should return new instance parsed from a string" do
    robots = Scrape::RobotsTxt.parse <<-TXT
    User-agent: Test
    Disallow: /foo
    Disallow: /bar
    TXT

    assert_equal ["Test"], robots.user_agents
    assert_equal ["/foo", "/bar"], robots.disallows
  end

  test ".parse should return new empty instance" do
    robots = Scrape::RobotsTxt.parse ""
    assert_equal [], robots.user_agents
    assert_equal [], robots.disallows
  end

  test ".load should return a new instance parsed from the specified url" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 200, :body => <<-TXT)
      User-agent: Test
      Disallow: /foo
      Disallow: /bar
      TXT

    robots = Scrape::RobotsTxt.load "http://www.example.com/robots.txt"
    assert_equal ["Test"], robots.user_agents
    assert_equal ["/foo", "/bar"], robots.disallows
  end

  test ".load should return a new instance parsed from the specified url with the path defaulted" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 200, :body => <<-TXT)
      User-agent: Test
      Disallow: /foo
      Disallow: /bar
      TXT

    robots = Scrape::RobotsTxt.load "http://www.example.com/foo"
    assert_equal ["Test"], robots.user_agents
    assert_equal ["/foo", "/bar"], robots.disallows
  end

  test ".load should return nil when specified url results in 404" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 404, :body => "")

    robots = Scrape::RobotsTxt.load "http://www.example.com/foo"
    assert_nil robots
  end
end