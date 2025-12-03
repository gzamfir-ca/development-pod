# frozen_string_literal: true

module Development
  # provides java-specific implementation
  class JavaPod < Pod
    # class private methods
    def fetch_data
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      system!(tool, nil)
    end

    def patch_file
      lines = File.readlines("settings.gradle")
      lines.select! do |line|
        line.strip.start_with?("include", "rootProject")
      end
      File.open("settings.gradle", "w") { |f| f.puts lines }
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} p_file call failed: #{e.message}"
      false
    end

    def setup_core
      fetch_data && patch_file
    end

    # class public methods
    def create
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = setup_core
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end

    def deploy
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      tool = %w[gradle run --console verbose]
      res_ok = system!(tool, nil)
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

      tool = %w[gradle test --continuous --console verbose]
      res_ok = system!(tool, nil)
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end
  end
end
