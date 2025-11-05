# frozen_string_literal: true

module Development
  # provides utilities implementation
  class Pod
    def ping
      "pong"
    end

    def version
      self.class::VERSION
    end
  end
end
