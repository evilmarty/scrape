require "test_helper"
require "scrape/cli"

class CLITest < Scrape::TestCase
  test "should use default file when none specified" do
    cli = Scrape::CLI.new "test", ""
    assert_equal File.join(Dir.pwd, 'Scrapefile'), cli.options[:file]
  end

  test "should use the specified file" do
    cli = Scrape::CLI.new "test", "-f /tmp/test1.scrape"
    assert_equal "/tmp/test1.scrape", cli.options[:file]
  end

  test "should not ignore robots.txt file when not specified" do
    cli = Scrape::CLI.new "test", ""
    assert_equal false, cli.options[:ignore_robots_txt]
  end

  test "should ignore robots.txt file when specified" do
    cli = Scrape::CLI.new "test", "-i"
    assert_equal true, cli.options[:ignore_robots_txt]
  end

  test "should set the user agent when specified" do
    user_agent = Scrape.user_agent
    cli = Scrape::CLI.new "test", "-u Test"
    assert_equal "Test", Scrape.user_agent
    Scrape.user_agent = user_agent
  end

  test "should exit when help is displayed" do
    assert_raises SystemExit do
      capture_io{ Scrape::CLI.new "test", "-h" }
    end
  end

  test "should exit when version is displayed" do
    assert_raises SystemExit do
      capture_io{ Scrape::CLI.new "test", "-v" }
    end
  end
end