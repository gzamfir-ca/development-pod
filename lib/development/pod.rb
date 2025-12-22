# frozen_string_literal: true

module Development
  # Provides utilities implementation
  class Pod
    ECHO_FILE = "ping"
    BASE_COLOR = "\e[0m"
    FAIL_COLOR = "\e[1;31m"
    PASS_COLOR = "\e[1;32m"
    WARN_COLOR = "\e[1;33m"
    FAIL_LABEL = "%s:%s not supported!"
    PASS_LABEL = "%s:%s has succeeded!"
    WARN_LABEL = "%s:%s not available!"
    STOP_LABEL = "%s:%s not completed!"

    # Class public methods
    def create
      execute_task(__method__, noop: true) { true }
    end

    def deploy
      execute_task(__method__, noop: true) { true }
    end

    def ping
      echo = read_data(self.class::ECHO_FILE)
      echo_fail = echo.nil? || echo.empty?

      log_outcome(__method__, !echo_fail, extra_message: echo)
      echo_fail ? 1 : 0
    end

    def remove
      execute_task(__method__) { safe_remove? && Development.remove_timestamp? }
    end

    def update
      execute_task(__method__, noop: true) { true }
    end

    def version
      log_outcome(__method__, true, extra_message: "version: #{self.class::VERSION}")
      0
    end

    # Class private methods
    def execute_task(method_name, noop: false)
      unless Development.operational?
        log_failure(method_name)
        return 1
      end

      res_ok = yield
      noop ? log_warning(method_name) : log_outcome(method_name, res_ok)
      res_ok ? 0 : 1
    end

    def log_failure(method_name)
      msg = format(FAIL_LABEL, self.class.name, method_name)
      puts "#{FAIL_COLOR}#{msg}#{BASE_COLOR}"
    end

    def log_outcome(method_name, res_ok, extra_message: nil)
      if extra_message && res_ok
        puts "#{PASS_COLOR}#{extra_message}#{BASE_COLOR}"
      else
        msg = format(select_label(res_ok), self.class.name, method_name)
        puts "#{select_color(res_ok)}#{msg}#{BASE_COLOR}"
      end
    end

    def log_warning(method_name)
      msg = format(WARN_LABEL, self.class.name, method_name)
      puts "#{WARN_COLOR}#{msg}#{BASE_COLOR}"
    end

    def read_data(file)
      path = Pathname.new(Development.data_path).expand_path
      path.join(file).read.strip
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} reading data failed: #{e.message}"
      ""
    end

    def safe_remove?
      Dir.children(".").each do |item|
        next if item == Development::CFG_FILE

        FileUtils.rm_rf(item, verbose: true, secure: true)
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} removing items failed: #{e.message}"
      false
    end

    def select_color(res_ok)
      res_ok ? PASS_COLOR : FAIL_COLOR
    end

    def select_label(res_ok)
      res_ok ? PASS_LABEL : STOP_LABEL
    end

    private(:execute_task, :log_failure, :log_outcome, :log_warning, :read_data,
            :safe_remove?, :select_color, :select_label)
  end
end
