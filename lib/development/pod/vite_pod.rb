# frozen_string_literal: true

module Development
  # provides vite-specific implementation
  class VitePod < Pod
    # class private methods
    def fetch_data
      tool = %w[npm create vite@latest app --].tap { |t| append_options(t) }
      system!(tool, nil)
    end

    def provide_options
      [{ "template" => "react-ts" }, { "no-interactive" => nil }]
    end

    def run_deploy
      tool1 = %w[npm run build]
      tool2 = %w[npm run preview]
      FileUtils.cd("app", verbose: true) do
        system!(tool1, nil) && system!(tool2, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def run_update
      tool1 = %w[npm install]
      tool2 = %w[npm run dev]
      FileUtils.cd("app", verbose: true) do
        system!(tool1, nil) && system!(tool2, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def setup_core
      update_options && fetch_data
    end

    def update_options
      return true if Development.item?(Development::OPT_NAME)

      Development.update_options(provide_options)
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

    def deploy
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = run_deploy
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

      res_ok = run_update
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end
  end
end
