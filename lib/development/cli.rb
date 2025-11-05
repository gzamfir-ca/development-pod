# frozen_string_literal: true

require "thor"

module Development
  # provides CLI implementation
  class CLI < Thor
    desc "version", "prints version number"

    def version
      puts pod.version
    end

    desc "ping", "provides a test reply"

    def ping
      puts pod.ping
    end

    no_commands do
      def pod
        @pod ||= Pod.new
      end
    end
  end
end
