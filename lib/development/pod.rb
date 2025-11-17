# frozen_string_literal: true

module Development
  # provides utilities implementation
  class Pod
    def create
      "#{self.class.name}:#{__method__} not implemented!"
    end

    def deploy
      "#{self.class.name}:#{__method__} not implemented!"
    end

    def ping
      Pathname.new(data_path(Development::GEM_NAME)).join("ping").read.strip
    end

    def update
      "#{self.class.name}:#{__method__} not implemented!"
    end

    def version
      self.class::VERSION
    end
  end
end
