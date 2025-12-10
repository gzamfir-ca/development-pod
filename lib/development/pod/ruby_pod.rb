# frozen_string_literal: true

module Development
  # provides ruby-specific implementation
  class RubyPod < Pod
    # class private methods
    def fetch_data?
      tool = %W[bundle gem #{Development.pod_name}].tap { |t| append_options(t) }
      system?(tool, nil)
    end

    def patch_data?
      tool = %w[bundle exec rake rubocop:autocorrect_all]
      FileUtils.cd(Development.pod_name, verbose: true) { system?(tool, nil) }
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def patch_file?
      res_ok = Development.token_gsub?("./#{Development.pod_name}/spec/#{Development.pod_name}_spec.rb", "false",
                                       "true")
      Development.token_gsub?("./#{Development.pod_name}/.rubocop.yml", "AllCops:",
                              "AllCops:\n  NewCops: enable\n  SuggestExtensions: false") && res_ok
      write_file?("./#{Development.pod_name}/Gemfile", ruby_data) && res_ok
    end

    def ruby_data
      <<~MULTILINE_CONTENT
        source "https://rubygems.org"
        gemspec
        gem "bundler", ">= 4.0.1"
        gem "irb", ">= 1.15.3"
        gem "rake", ">= 13.3.1"
        gem "rerun", ">= 0.14.0"
        gem "rspec", ">= 3.13.2"
        gem "rubocop", ">= 1.81.7"
      MULTILINE_CONTENT
    end

    def run_deploy?
      tool1 = %w[bundle exec rake build]
      tool2 = %w[bundle exec rake install]
      FileUtils.cd(Development.pod_name, verbose: true) do
        system?(tool1, nil) && system?(tool2, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def run_update?
      tool1 = %w[bundle install]
      tool2 = %w[bundle exec rerun --clear --exit --verbose rspec]
      FileUtils.cd(Development.pod_name, verbose: true) do
        system?(tool1, nil) && system?(tool2, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_data?
    end

    def update_options?
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options?([{ "exe" => nil }])
    end

    def write_file?(file, data)
      File.open(file, "w") do |f|
        f << data
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} p_file call failed: #{e.message}"
      false
    end

    # class public methods
    def create
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = setup_core? && Development.append_timestamp?
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

      res_ok = run_deploy?
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

      res_ok = run_update?
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end
  end
end
