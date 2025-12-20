# frozen_string_literal: true

module Development
  # Provides CLI implementation
  class CLI < Thor
    # Class public methods
    def self.exit_on_failure?
      true
    end

    def self.start(given_args = ARGV, config = {})
      Development.setup
      super
    end

    desc "create", "Creates a runtime pod"

    def create
      execute_command(__method__)
    end

    desc "deploy", "Deploys a runtime pod"

    def deploy
      execute_command(__method__)
    end

    desc "help [COMMAND]", "Describes cli command"

    def help(command = nil)
      super
    end

    desc "ping", "Provides a test reply"

    def ping
      execute_command(__method__)
    end

    desc "remove", "Removes a runtime pod"

    def remove
      execute_command(__method__)
    end

    desc "update", "Updates a runtime pod"

    def update
      execute_command(__method__)
    end

    desc "version", "Prints version number"

    def version
      execute_command(__method__)
    end

    # Class private methods

    private

    def execute_command(command)
      puts "#{self.class.name}:#{__method__} executing #{command}..."
      exit Development.runtime.send(command || :undefined)
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} command failed: #{e.message}"
      exit 1
    end
  end
end
