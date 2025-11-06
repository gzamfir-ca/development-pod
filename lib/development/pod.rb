# frozen_string_literal: true

module Development
  # provides utilities implementation
  class Pod
    def create
      "create not implemented for #{self.class.name}"
    end

    def deploy
      "deploy not implemented for #{self.class.name}"
    end

    def ping
      "pong"
    end

    def update
      "update not implemented for #{self.class.name}"
    end

    def version
      self.class::VERSION
    end
  end
end
