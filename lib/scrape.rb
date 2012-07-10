require "rubygems"
require "logger"
require "bundler/setup"

module Scrape
  require 'scrape/version'

  autoload 'Application', 'scrape/application'
  autoload 'Site', 'scrape/site'
  autoload 'Match', 'scrape/match'
  autoload 'DefaultLoader', 'scrape/default_loader'
  autoload 'DSL', 'scrape/dsl'
  autoload 'URI', 'scrape/uri'

  class ScrapeFileNotFound < Exception; end

  class << self
    attr_writer :user_agent

    def user_agent
      @user_agent || "Scrape/#{Scrape::VERSION}"
    end

    def logger
      @logger ||= Logger.new STDOUT
    end

    def logger= log
      @logger = log
    end

    def load_scrapefile path
      Application.new path
    end
  end
end