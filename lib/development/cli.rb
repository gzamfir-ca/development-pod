# frozen_string_literal: true

module Development
  # provides CLI implementation
  class CLI < Thor
    # class private methods
    def self.exit_on_failure?
      true
    end

    def self.start(given_args = ARGV, config = {})
      Development.setup
      super
    end

    # class public methods
    desc "create", "creates a runtime pod"

    def create
      exit Development.runtime.create
    end

    desc "deploy", "deploys a runtime pod"

    def deploy
      exit Development.runtime.deploy
    end

    desc "help [COMMAND]", "describes cli command"

    def help(command = nil)
      super(command)
    end

    desc "ping", "provides a test reply"

    def ping
      exit Development.runtime.ping
    end

    desc "remove", "removes a runtime pod"

    def remove
      exit Development.runtime.remove
    end

    desc "update", "updates a runtime pod"

    def update
      exit Development.runtime.update
    end

    desc "version", "prints version number"

    def version
      exit Development.runtime.version
    end
  end
end
