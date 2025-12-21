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

    def patch_gemspec?
      gs_file = Pathname.new("./#{Development.pod_name}/#{Development.pod_name}.gemspec").expand_path
      gs_desc = "#{Development.pod_name} is a ruby gem"
      gs_abre = "#{Development.pod_name} does something"
      gs_prop = "https://github.com/gzamfir-ca/#{Development.pod_name}"
      gs_serv = "https://rubygems.org"
      token_gsub?(gs_file, "TODO: Write a short summary, because RubyGems requires one.", gs_abre) &&
        token_gsub?(gs_file, "TODO: Write a longer description or delete this line.", gs_desc) &&
        token_gsub?(gs_file, "TODO: Put your gem's website or public repo URL here.", gs_prop) &&
        token_gsub?(gs_file, "TODO: Put your gem's public repo URL here.", gs_prop) &&
        token_gsub?(gs_file, "TODO: Set to your gem server 'https://example.com'", gs_serv)
    end

    def patch_file?
      gm_file = Pathname.new("./#{Development.pod_name}/Gemfile").expand_path
      rc_file = Pathname.new("./#{Development.pod_name}/.rubocop.yml").expand_path
      rc_prop = "AllCops:\n  NewCops: enable\n  SuggestExtensions: false"
      rc_skip = "AllCops:\n  Exclude:\n    - 'bin/*'"
      update_file?(gm_file, "w", ruby_data) &&
        token_gsub?(rc_file, "AllCops:", rc_prop) &&
        token_gsub?(rc_file, "AllCops:", rc_skip) &&
        token_gsub?(spec_file, "false", "true") &&
        patch_gemspec?
    end

    def patch_path?
      tool = %w[bundle exec rake rubocop:autocorrect_all]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
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
      tool1 = %w[bundle install]
      tool2 = %w[bundle exec rerun --clear --exit --verbose rspec]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool1, tool2])
    end

    def spec_file
      tokens = Development.pod_name.split("-")
      spec_file = "./#{Development.pod_name}/spec/#{Development.pod_name}_spec.rb"
      spec_file = "./#{Development.pod_name}/spec/#{tokens[0]}/#{tokens[1]}_spec.rb" if tokens.length > 1
      Pathname.new(spec_file).expand_path
    end
  end
end
