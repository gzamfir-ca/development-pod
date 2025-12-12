# frozen_string_literal: true

module Development
  # provides utilities implementation
  class Pod
    ECHO_FILE = "ping"
    BACK_COLOR = "\e[0m"
    FAIL_COLOR = "\e[1;31m"
    PASS_COLOR = "\e[1;32m"
    THEN_COLOR = "\e[1;33m"
    FAIL_MSG = "%s:%s not supported!"
    THEN_MSG = "%s:%s not available!"

    # class private methods
    def read_data(file)
      path = Pathname.new(Development.data_path).expand_path
      path.join(file).read.strip
    rescue StandardError => e
      puts "#{name}:#{__method__} reading data failed: #{e.message}"
      ""
    end

    def safe_remove?
      Dir.children(".").each do |item|
        FileUtils.rm_rf(item, verbose: true, secure: true) unless item == Development::CFG_FILE
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} removing items failed: #{e.message}"
      false
    end

    # class protected methods
    def test_msg(res_ok)
      res_ok ? "%s:%s succeeded!" : "%s:%s failed!"
    end

    def test_color(res_ok)
      res_ok ? PASS_COLOR : FAIL_COLOR
    end

    # class public methods
    def create
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      msg = format(THEN_MSG, self.class.name, __method__)
      puts "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
      0
    end

    def deploy
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      msg = format(THEN_MSG, self.class.name, __method__)
      puts "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
      0
    end

    def ping
      echo = read_data(self.class::ECHO_FILE)
      echo_fail = echo.nil? || echo.empty?
      if echo_fail
        msg = format(test_msg(!echo_fail), self.class.name, __method__)
        puts "#{test_color(!echo_fail)}#{msg}#{BACK_COLOR}"
        return 1
      end

      puts "#{PASS_COLOR}#{echo}#{BACK_COLOR}"
      0
    end

    def remove
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = safe_remove? && Development.remove_timestamp?
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end

    def update
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      msg = format(THEN_MSG, self.class.name, __method__)
      puts "#{THEN_COLOR}#{msg}#{BACK_COLOR}"
      0
    end

    def version
      puts "#{PASS_COLOR}#{self.class::VERSION}#{BACK_COLOR}"
      0
    end
  end
end
