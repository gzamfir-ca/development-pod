# frozen_string_literal: true

require "thor"

module Development
  # provides CLI implementation
  class CLI < Thor
    desc "version", "prints version number"

    def version
      puts Development.runtime.class.name
      puts Development.runtime.version
    end

    desc "ping", "provides a test reply"

    def ping
      puts Development.runtime.class.name
      puts Development.runtime.ping
    end
  end
end
