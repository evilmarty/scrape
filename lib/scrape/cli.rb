require "optparse"
require File.expand_path("../../scrape", __FILE__)

class Scrape::CLI
  attr_reader :command, :app, :options

  def initialize command, argv = ""
    @command = command
    @options = {:file => File.join(Dir.pwd, 'Scrapefile'), :ignore_robots_txt => false}

    opts = OptionParser.new do |opts|
      opts.banner = "Scrape #{Scrape::VERSION} - Usage: #{command} [options]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on "-f", "--scrapefile [FILE]", "Use FILE as scrapefile" do |file|
        @options[:file] = File.expand_path file.strip
      end
      opts.on "-i", "--ignore-robots-txt", "Ignore robots.txt" do
        @options[:ignore_robots_txt] = true
      end
      opts.on "-u", "--user-agent [AGENT]", "Change the user agent" do |agent|
        Scrape.user_agent = agent.strip
      end
      opts.on_tail "-h", "--help", "Show this message" do
        puts opts
        exit
      end
      opts.on_tail "-v", "--version", "Show version" do
        puts Scrape::VERSION
        exit
      end
    end
    opts.parse argv

    @app = Scrape::Application.new options[:file], options
  end

  def run
    app.run
    exit
  rescue SystemExit, Interrupt
    puts ""
    exit
  rescue Scrape::FileNotFound
    puts "#{command} aborted!"
    puts "No Scrapefile found"
    exit -1
  end
end