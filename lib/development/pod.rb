# frozen_string_literal: true

module Development
  # provides utilities implementation
  class Pod
    def append_options(tool)
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "--#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
    end

    def run_all(*toolset)
      toolset.all? { |tool| system!(*tool) }
    end

    def create
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def ping
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      data_path = Development.data_path
      raise "data_path is nil" if data_path.nil?

      data_path.join("ping").read.strip
    rescue StandardError => e
      "#{self.class.name}:#{__method__} failed: #{e.message}"
    end

    def update
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def version
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      self.class::VERSION
    end
  end
end
