# frozen_string_literal: true

module Development
  # provides ruby-specific implementation
  class RubyPod < Pod
    # class private methods
    def fetch_data?
      app = Development.pod_name
      tool = %W[bundle gem #{app}].tap { |t| append_options(t) }
      system?(tool, nil)
    end

    def patch_data?
      app = Development.pod_name
      tool = %w[bundle exec rake rubocop:autocorrect_all]
      FileUtils.cd(app, verbose: true) do
        system?(tool, nil)
      end
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def patch_file?
      app = Development.pod_name
      path = "./#{app}/spec/#{app}_spec.rb"
      res_ok = Development.token_gsub?(path, "false", "true")
      path = "./#{app}/.rubocop.yml"
      original = "AllCops:"
      replacement = "AllCops:\n  NewCops: enable\n  SuggestExtensions: false"
      Development.token_gsub?(path, original, replacement) && res_ok
      write_file?("./#{app}/Gemfile", ruby_data) && res_ok
    end

    def provide_options
      [{ "exe" => nil }]
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

    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_data?
    end

    def update_options?
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options?(provide_options)
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
  end
end
