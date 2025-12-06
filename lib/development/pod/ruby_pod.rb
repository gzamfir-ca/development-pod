# frozen_string_literal: true

module Development
  # provides ruby-specific implementation
  class RubyPod < Pod
    # class private methods
    def fetch_data
      tool = %w[bundle gem app].tap { |t| append_options(t) }
      system!(tool, nil)
    end

    def setup_core
      fetch_data
    end

    # class public methods
    def create
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = setup_core && Development.append_timestamp
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end
  end
end
