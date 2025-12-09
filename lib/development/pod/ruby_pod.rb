# frozen_string_literal: true

module Development
  # provides ruby-specific implementation
  class RubyPod < Pod
    # class private methods
    def fetch_data
      app = Development.pod_name
      tool = %W[bundle gem #{app}].tap { |t| append_options(t) }
      system!(tool, nil)
    end

    def patch_data
      app = Development.pod_name
      tool = %w[bundle exec rake rubocop:autocorrect_all]
      FileUtils.cd(app, verbose: true) do
        system!(tool, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def patch_file
      app = Development.pod_name
      path = "./#{app}/spec/#{app}_spec.rb"
      Development.token_gsub(path, "false", "true")
    end

    def provide_options
      [{ "bundle" => nil }, { "exe" => nil }]
    end

    def setup_core
      update_options && fetch_data && patch_data && patch_file
    end

    def update_options
      return true if Development.entry?(Development::OPT_NAME)

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
  end
end
