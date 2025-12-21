# frozen_string_literal: true

module Development
  # Provides java-specific utilities implementation
  class JavaPod < CorePod
    private

    # Class private methods
    include Hub

    def fetch_data?
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      path = Pathname.new(".").expand_path
      run_tools?(path, [tool])
    end

    def patch_file?
      gb_file = Pathname.new("app/build.gradle").expand_path
      gs_file = Pathname.new("settings.gradle").expand_path
      gb_libs = "'com.me.libs:libext:1.0.0'"
      gb_repo = "mavenCentral()\n    mavenLocal()"
      gb_prop = "useJUnitPlatform()\n    testLogging {\n        showStandardStreams = true\n    }"
      filter_file?(gs_file, %w[rootProject]) &&
        token_gsub?(gb_file, "libs.guava", gb_libs) &&
        token_gsub?(gb_file, "mavenCentral()", gb_repo) &&
        token_gsub?(gb_file, "useJUnitPlatform()", gb_prop)
    end

    def patch_path?
      items = %w[.gitattributes .gitignore gradle gradle.properties gradlew gradlew.bat settings.gradle]
      src = Pathname.new("app").expand_path
      dest = Pathname.new(Development.pod_name).expand_path
      paths = items.map { |item| Pathname(item).expand_path }
      move_item?(src, dest) && paths.all? { |path| move_item?(path, dest) }
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
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
    end

    def run_update?
      tool = %w[gradle test --continuous --console verbose]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
    end
  end
end
