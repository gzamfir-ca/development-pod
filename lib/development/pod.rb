# frozen_string_literal: true

require_relative "pod/version"

module Development
  # This class provides a simple ping/pong service.
  class Pod
    def self.ping
      "pong"
    end
  end
end
