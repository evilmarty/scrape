require "optparse"

class Scrape::CLI
  attr_reader :command, :pwd

  def initialize command, pwd = Dir.pwd
    @command, @pwd = command, pwd
  end

  def run argv
    options = {:file => File.join(pwd, 'Scrapefile')}
    opts = OptionParser.new do |opts|
      opts.banner = "Scrape #{Scrape::VERSION} - Usage: #{command} [options]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on "-f", "--scrapefile [FILE]", "Use FILE as scrapefile" do |file|
        options[:file] = File.expand_path file
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

    if File.exists? options[:file]
      Scrape::Application.new(options[:file]).run
    else
      puts "#{command} aborted!"
      puts "No Scrapefile found"
      exit -1
    end
  end
end