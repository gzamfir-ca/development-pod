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
      data_path = Development.data_path
      raise "data_path is nil" if data_path.nil?

      data_path.join("ping").read.strip
    rescue StandardError => e
      "#{self.class.name}:#{__method__} failed: #{e.message}"
    end

    def update
      "#{self.class.name}:#{__method__} not implemented!"
    end

    def version
      self.class::VERSION
    end
  end
end
