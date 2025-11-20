# frozen_string_literal: true

require "fileutils"

module Development
  # provides utilities implementation
  class Pod
    ECHO_FILE = "ping"

    def append_options(tool)
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "--#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
    end

    def create
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def ping
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      Development.read_data(self.class::ECHO_FILE)
    end

    def remove
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      res_ok = safe_remove
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end

    def run_all(*toolset)
      toolset.all? { |tool| system!(*tool) }
    end

    def safe_remove
      Dir.children(".").each do |item|
        next if item == "pod.yaml"

        FileUtils.rm_rf item unless Development.protected?
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} remove call failed: #{e.message}"
      false
    end

    def update
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def version
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      self.class::VERSION
    end
  end
end
