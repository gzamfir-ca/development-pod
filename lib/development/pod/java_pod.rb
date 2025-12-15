# frozen_string_literal: true

module Development
  # provides java-specific utilities implementation
  class JavaPod < CorePod
    # class private methods
    include Hub

    def fetch_data?
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      run_tools?(".", [tool])
    end

    def patch_file?
      gb_file = "app/build.gradle"
      gb_libs = "'com.me.libs:libext:1.0.0'"
      gb_repo = "mavenCentral()\n    mavenLocal()"
      gb_prop = "useJUnitPlatform()\n    testLogging {\n        showStandardStreams = true\n    }"
      res_ok = filter_file?("settings.gradle", %w[rootProject])
      res_ok = token_gsub?(gb_file, "libs.guava", gb_libs) && res_ok
      res_ok = token_gsub?(gb_file, "mavenCentral()", gb_repo) && res_ok
      token_gsub?(gb_file, "useJUnitPlatform()", gb_prop) && res_ok
    end

    def patch_path?
      items = %w[.gitattributes .gitignore gradle gradle.properties gradlew gradlew.bat settings.gradle]
      res_ok = move_item?("app", Development.pod_name)
      items.each do |item|
        res_ok = move_item?(item, Development.pod_name) && res_ok
      end
      res_ok
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
      run_tools?(Development.pod_name, [tool])
    end

    def run_update?
      tool = %w[gradle test --continuous --console verbose]
      run_tools?(Development.pod_name, [tool])
    end
  end
end
