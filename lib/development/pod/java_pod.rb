# frozen_string_literal: true

module Development
  # provides java-specific implementation
  class JavaPod < CorePod
    # class private methods
    include Hub

    def fetch_data?
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      run_tools?(".", [tool])
    end

    def patch_data?
      true
    end

    def patch_file?
      filter_file?("settings.gradle", %w[include rootProject])
    end

    def provide_options
      [{ "type" => "java-application" },
       { "dsl" => "groovy" },
       { "test-framework" => "junit-jupiter" },
       { "package" => "com.me.demo" },
       { "project-name" => "demo" },
       { "java-version" => 25 },
       { "no-comments" => nil },
       { "no-incubating" => nil },
       { "no-split-project" => nil },
       { "overwrite" => nil }]
    end

    def run_deploy?
      tool = %w[gradle run --console verbose]
      run_tools?("app", [tool])
    end

    def run_update?
      tool = %w[gradle test --continuous --console verbose]
      run_tools?("app", [tool])
    end
  end
end
