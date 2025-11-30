# frozen_string_literal: true

require "fileutils"

module Development
  # provides utilities implementation
  class Pod
    ECHO_FILE = "ping"
    BACK_COLOR = "\e[0m"
    FAIL_COLOR = "\e[1;31m"
    PASS_COLOR = "\e[1;32m"
    THEN_COLOR = "\e[1;35m"
    FAIL_MSG = "%s:%s not supported!"
    THEN_MSG = "%s:%s not available!"

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
    def append_options(tool, sep: "--")
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "#{sep}#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
    end

    def copy_item(src_dir, dest_dir)
      FileUtils.cp_r(src_dir, dest_dir, verbose: true, preserve: true)
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} u_copy call failed: #{e.message}"
      false
    end

    def move_item(src_dir, dest_dir)
      FileUtils.mv(src_dir, dest_dir, verbose: true, secure: true)
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} u_move call failed: #{e.message}"
      false
    end

    def test_msg(res_ok)
      res_ok ? "%s:%s succeeded!" : "%s:%s failed!"
    end

    def test_color(res_ok)
      res_ok ? PASS_COLOR : FAIL_COLOR
    end

    # class public methods
    def create
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      msg = format(THEN_MSG, self.class.name, __method__)
      "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
    end

    def deploy
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      msg = format(THEN_MSG, self.class.name, __method__)
      "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
    end

    def ping
      Development.read_data(self.class::ECHO_FILE)
    end

    def remove
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      res_ok = safe_remove
      msg = format(test_msg(res_ok), self.class.name, __method__)
      "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
    end

    def update
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      msg = format(THEN_MSG, self.class.name, __method__)
      "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
    end

    def version
      self.class::VERSION
    end
  end
end
