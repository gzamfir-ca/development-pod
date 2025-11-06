# frozen_string_literal: true

require "thor"

module Development
  # provides CLI implementation
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "create", "creates a runtime pod"

    def create
      puts Development.runtime.class.name
      puts Development.runtime.create
    end

    desc "deploy", "deploys a runtime pod"

    def deploy
      puts Development.runtime.class.name
      puts Development.runtime.deploy
    end

    desc "help [COMMAND]", "describes cli command"

    def help(command = nil)
      super(command)
    end

    desc "ping", "provides a test reply"

    def ping
      puts Development.runtime.class.name
      puts Development.runtime.ping
    end

    desc "update", "updates a runtime pod"

    def update
      puts Development.runtime.class.name
      puts Development.runtime.update
    end

    desc "version", "prints version number"

    def version
      puts Development.runtime.class.name
      puts Development.runtime.version
    end
  end
end
