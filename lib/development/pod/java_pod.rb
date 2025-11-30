# frozen_string_literal: true

module Development
  # provides java-specific implementation
  class JavaPod < Pod
    # class private methods
    def fetch_data
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      system!(tool)
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

    # class public methods
    def create
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      res_ok = fetch_data
      res_ok = patch_file && res_ok
      msg = format(test_msg(res_ok), self.class.name, __method__)
      "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
    end

    def deploy
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      tool = %w[gradle run --console verbose]
      res_ok = system!(tool)
      msg = format(test_msg(res_ok), self.class.name, __method__)
      "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
    end

    def update
      msg = format(FAIL_MSG, self.class.name, __method__)
      return "#{FAIL_COLOR}#{msg}#{BACK_COLOR}" unless Development.operational?

      tool = %w[gradle test --continuous --console verbose]
      res_ok = system!(tool)
      msg = format(test_msg(res_ok), self.class.name, __method__)
      "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
    end
  end
end
