# frozen_string_literal: true

module Development
  # provides ruby-specific utilities implementation
  class RubyPod < CorePod
    # class private methods
    include Hub

    def fetch_data?
      tool = %W[bundle gem #{Development.pod_name}].tap { |t| append_options(t) }
      run_tools?(".", [tool])
    end

    def patch_gemspec?
      gs_desc = "#{Development.pod_name} is a ruby gem"
      gs_abre = "#{Development.pod_name} does something"
      gs_file = "./#{Development.pod_name}/#{Development.pod_name}.gemspec"
      gs_prop = "https://github.com/gzamfir-ca/#{Development.pod_name}"
      gs_serv = "https://rubygems.org"
      res_ok = token_gsub?(gs_file, "TODO: Write a short summary, because RubyGems requires one.", gs_abre)
      res_ok = token_gsub?(gs_file, "TODO: Write a longer description or delete this line.", gs_desc) && res_ok
      res_ok = token_gsub?(gs_file, "TODO: Put your gem's website or public repo URL here.", gs_prop) && res_ok
      res_ok = token_gsub?(gs_file, "TODO: Put your gem's public repo URL here.", gs_prop) && res_ok
      token_gsub?(gs_file, "TODO: Set to your gem server 'https://example.com'", gs_serv) && res_ok
    end

    def patch_file?
      gm_file = "./#{Development.pod_name}/Gemfile"
      rc_file = "./#{Development.pod_name}/.rubocop.yml"
      rc_prop = "AllCops:\n  NewCops: enable\n  SuggestExtensions: false"
      rc_skip = "AllCops:\n  Exclude:\n    - 'bin/*'"
      res_ok = update_file?(gm_file, "w", ruby_data)
      res_ok = token_gsub?(rc_file, "AllCops:", rc_prop) && res_ok
      res_ok = token_gsub?(rc_file, "AllCops:", rc_skip) && res_ok
      res_ok = token_gsub?(spec_file, "false", "true") && res_ok
      patch_gemspec? && res_ok
    end

    def patch_path?
      tool = %w[bundle exec rake rubocop:autocorrect_all]
      run_tools?(Development.pod_name, [tool])
    end

    def provide_options
      [{ "exe" => nil }]
    end

    def ruby_data
      <<~MULTILINE_CONTENT
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
      MULTILINE_CONTENT
    end

    def run_deploy?
      tool1 = %w[bundle exec rake build]
      tool2 = %w[bundle exec rake install]
      run_tools?(Development.pod_name, [tool1, tool2])
    end

    def run_update?
      tool1 = %w[bundle install]
      tool2 = %w[bundle exec rerun --clear --exit --verbose rspec]
      run_tools?(Development.pod_name, [tool1, tool2])
    end

    def spec_file
      name_parts = Development.pod_name.split("-")
      if name_parts.length > 1
        "./#{Development.pod_name}/spec/#{name_parts[0]}/#{name_parts[1]}_spec.rb"
      else
        "./#{Development.pod_name}/spec/#{Development.pod_name}_spec.rb"
      end
    end
  end
end
