# frozen_string_literal: true

require "fileutils"

module Development
  # provides utilities implementation
  class Pod
    ECHO_FILE = "ping"

    # class private methods
    def safe_remove
      Dir.children(".").each do |item|
        FileUtils.rm_rf(item, verbose: true, secure: true) unless item == Development::CFG_FILE
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} remove call failed: #{e.message}"
      false
    end

    # class protected methods
    def append_options(tool)
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "--#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
    end

    def bulk_copy(src_dir, dest_dir)
      src_paths = Dir.children(src_dir).map { |f| File.join(src_dir, f) }
      FileUtils.cp_r(src_paths, dest_dir, verbose: true, preserve: true)
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} copy_r call failed: #{e.message}"
      false
    end

    def run_all(*toolset)
      toolset.all? { |tool| system!(*tool) }
    end

    # class public methods
    def create
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def ping
      Development.read_data(self.class::ECHO_FILE)
    end

    def remove
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      res_ok = safe_remove
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end

    def update
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      "#{self.class.name}:#{__method__} not implemented!"
    end

    def version
      self.class::VERSION
    end
  end
end
