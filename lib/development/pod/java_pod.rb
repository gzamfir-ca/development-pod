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

    def patch_build?
      substitutions = {
        "testImplementation libs.junit.jupiter" => "testImplementation('org.junit.jupiter:junit-jupiter:6.0.3')\n\
    testImplementation('org.hamcrest:hamcrest:3.0')",
        "libs.guava" => "'com.me.libs:libext:1.0.0'",
        "mavenCentral()" => "mavenCentral()\n    mavenLocal()",
        "useJUnitPlatform()" => "useJUnitPlatform()\n    testLogging {\n        showStandardStreams = true\n    }"
      }
      file = Pathname.new("app/build.gradle").expand_path
      substitutions.all? { |search, replace| token_gsub?(file, search, replace) }
    end

    def patch_file?
      file = Pathname.new("settings.gradle").expand_path
      filter_file?(file, %w[rootProject]) && patch_build?
    end

    def patch_items?
      dest = Pathname.new(Development.pod_name).expand_path
      items = %w[.gitattributes .gitignore gradle gradle.properties gradlew gradlew.bat settings.gradle]
      paths = items.map { |item| Pathname(item).expand_path }
      paths.all? { |path| move_item?(path, dest) }
    end

    def patch_path?
      src = Pathname.new("app").expand_path
      dest = Pathname.new(Development.pod_name).expand_path
      move_item?(src, dest) && patch_items?
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
