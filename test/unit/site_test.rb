require "test_helper"

class SiteTest < Scrape::TestCase
  test "#add_match should create a Match object and be added to the collection" do
    site = Scrape::Site.new "http://www.example.com"
    match = site.add_match("/test") { |doc| }
    assert_instance_of Scrape::Match, match
  end

  test "#open should include cookie header when cookie option is set" do
    stub_request(:get, "http://www.example.com/").
      with(:headers => {'Cookie' => 'omnom'}).
      to_return(:status => 200, :body => "")

    site = Scrape::Site.new "http://www.example.com", :cookie => "omnom"
    site.open "http://www.example.com"
  end

  test "#open should include cookie header when cookie option is a hash" do
    stub_request(:get, "http://www.example.com/").
      with(:headers => {'Cookie' => 'foo=bar'}).
      to_return(:status => 200, :body => "")

    site = Scrape::Site.new "http://www.example.com", :cookie => {:foo => "bar"}
    site.open "http://www.example.com"
  end

  test "#parse should return absolute urls that match the site's url" do
    stub_request(:get, "http://www.example.com/test").
      with(:headers => {"User-Agent" => Scrape.user_agent}).
      to_return(:status => 200, :body => <<-HTML)
      <html>
        <body>
          <a href="http://www.example.com/link1.html">link 1</a>
          <a href="http://example.com/link2.html">link 2</a>
          <a href="http://example.org/link3.html">link 3</a>
        </body>
      </html>
    HTML

    site = Scrape::Site.new "http://www.example.com"
    assert_equal ["http://www.example.com/link1.html"], site.parse("/test")
  end

  test "#parse should return relative urls to the specified url" do
    stub_request(:get, "http://www.example.com/foo/bar").
      with(:headers => {"User-Agent" => Scrape.user_agent}).
      to_return(:status => 200, :body => <<-HTML)
      <html>
        <body>
          <a href="link1.html">link 1</a>
        </body>
      </html>
    HTML

    site = Scrape::Site.new "http://www.example.com"
    assert_equal ["http://www.example.com/foo/link1.html"], site.parse("/foo/bar")
  end

  test "#parse should return no urls" do
    stub_request(:get, "http://www.example.com/test").
      with(:headers => {"User-Agent" => Scrape.user_agent}).
      to_return(:status => 200, :body => <<-HTML)
      <html>
        <body>
          <a href="/link1.html">link 1</a>
        </body>
      </html>
    HTML

    site = Scrape::Site.new "http://www.example.com/test"
    assert_equal [], site.parse("/test")
  end

  test "#parse should invoke Match when hit" do
    stub_request(:get, "http://www.example.com/test").
      with(:headers => {"User-Agent" => Scrape.user_agent}).
      to_return(:status => 200, :body => <<-HTML)
      <html>
        <body>
          <a href="link1.html">link 1</a>
        </body>
      </html>
    HTML

    ok = false
    site = Scrape::Site.new "http://www.example.com"
    site.add_match(/test/){|doc| ok = true }
    site.parse "/test"

    assert ok, "Match was not invoked"
  end

  test "#accept? should return true when specified url is inside the site's url" do
    site = Scrape::Site.new "http://www.example.com/foo"
    assert site.accept?("http://www.example.com/foo/bar")
  end

  test "#accept? should return false when specified url is outside the site's url" do
    site = Scrape::Site.new "http://www.example.com/foo"
    refute site.accept?("http://www.example.com/bar")
  end

  test "#accept? should return true when specified url is inside the site's url and allowed by robots.txt" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 200, :body => <<-TXT)
      User-agent: #{Scrape.user_agent}
      Disallow: /bar
      TXT

    site = Scrape::Site.new "http://www.example.com/foo", :ignore_robots_txt => false
    assert site.accept?("http://www.example.com/foo/bar")
  end

  test "#accept? should return false when specified url is inside the site's url and disallowed by robots.txt" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 200, :body => <<-TXT)
      User-agent: #{Scrape.user_agent}
      Disallow: /foo
      TXT

    site = Scrape::Site.new "http://www.example.com/foo", :ignore_robots_txt => false
    refute site.accept?("http://www.example.com/foo/bar"), "URL should not be accepted"
  end

  test "#normalize should return a url when string begins with a slash" do
    site = Scrape::Site.new "http://www.example.com/foo"
    assert_equal "http://www.example.com/bar", site.normalize("/bar")
  end

  test "#normalize should return a url with the string appended" do
    site = Scrape::Site.new "http://www.example.com/foo/boo"
    assert_equal "http://www.example.com/foo/bar", site.normalize("bar")
  end

  test "#normalize should return the string when it begins with a scheme" do
    site = Scrape::Site.new "http://www.example.com/foo"
    assert_equal "http://www.example.org/bar", site.normalize("http://www.example.org/bar")
  end

  test "#normalize should return a url when string is a forward slash" do
    site = Scrape::Site.new "http://www.example.com/foo"
    assert_equal "http://www.example.com/", site.normalize("/")
  end

  test "#robots_txt should return a RobotsTxt instance from the site's url" do
    stub_request(:get, "http://www.example.com/robots.txt").
      to_return(:status => 200, :body => <<-TXT)
      User-agent: Test
      Disallow: /foo
      TXT

    site = Scrape::Site.new "http://www.example.com/foo"
    robots = site.robots_txt
    assert_kind_of Scrape::RobotsTxt, robots
  end
end