# frozen_string_literal: true

require "thor"

module Development
  # provides CLI implementation
  class CLI < Thor
    desc "version", "prints version number"

    def version
      puts Development::Pod::VERSION
    end

    desc "ping", "provides a test reply"

    def ping
      puts Development::Pod.ping
    end
  end
end
