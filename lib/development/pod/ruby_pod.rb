# frozen_string_literal: true

module Development
  # Provides ruby-specific utilities implementation
  class RubyPod < CorePod
    private

    # Class private methods
    include Hub

    def fetch_data?
      tool = %W[bundle gem #{Development.pod_name}].tap { |t| append_options(t) }
      path = Pathname.new(".").expand_path
      run_tools?(path, [tool])
    end

    def patch_attributes?
      patch_gemspec? && patch_spec?
    end

    def patch_build?
      patch_rubocop? && patch_attributes?
    end

    def patch_file?
      file = Pathname.new("./#{Development.pod_name}/Gemfile").expand_path
      update_file?(file, "w", ruby_data) && patch_build?
    end

    def patch_gemspec?
      substitutions = {
        "TODO: Write a short summary, because RubyGems requires one." => "#{Development.pod_name} does something",
        "TODO: Write a longer description or delete this line." => "#{Development.pod_name} is a ruby gem",
        "TODO: Put your gem's website or public repo URL here." => "https://github.com/gzamfir-ca/#{Development.pod_name}",
        "TODO: Put your gem's public repo URL here." => "https://github.com/gzamfir-ca/#{Development.pod_name}",
        "TODO: Set to your gem server 'https://example.com'" => "https://rubygems.org"
      }
      file = Pathname.new("./#{Development.pod_name}/#{Development.pod_name}.gemspec").expand_path
      substitutions.all? { |search, replace| token_gsub?(file, search, replace) }
    end

    def patch_path?
      tool1 = %w[bundle exec rake rubocop:autocorrect_all]
      tool2 = %w[bundle install]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool1, tool2])
    end

    def patch_rubocop?
      substitutions = {
        "AllCops:" => "AllCops:\n  NewCops: enable\n  SuggestExtensions: false",
        "AllCops:\n  NewCops:" => "AllCops:\n  Exclude:\n    - 'bin/*'\n  NewCops:"
      }
      file = Pathname.new("./#{Development.pod_name}/.rubocop.yml").expand_path
      substitutions.all? { |search, replace| token_gsub?(file, search, replace) }
    end

    def patch_spec?
      tokens = Development.pod_name.split("-")
      spec = "./#{Development.pod_name}/spec/#{Development.pod_name}_spec.rb"
      spec = "./#{Development.pod_name}/spec/#{tokens[0]}/#{tokens[1]}_spec.rb" if tokens.length > 1
      file = Pathname.new(spec).expand_path
      token_gsub?(file, "false", "true")
    end

    def provide_options
      [{ "exe" => nil }]
    end

    def ruby_data
      <<~RUBY_DATA
        source "https://rubygems.org"

        gemspec

        group :development do
          gem "bundler", ">= 4.0.1"
          gem "irb", ">= 1.15.3"
          gem "rake", ">= 13.3.1"
          gem "rerun", ">= 0.14.0"
          gem "rspec", ">= 3.13.2"
          gem "rubocop", ">= 1.81.7"
        end
      RUBY_DATA
    end

    def run_deploy?
      tool1 = %w[bundle exec rake build]
      tool2 = %w[bundle exec rake install]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool1, tool2])
    end

    def run_update?
      tool = %w[bundle exec rerun --clear --exit rspec]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
    end
  end
end
