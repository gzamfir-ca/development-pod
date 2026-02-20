# frozen_string_literal: true

module Development
  # Provides java-specific utilities implementation
  class JavaPod < CorePod
    private

    # Class private methods
    include Hub

    def conf_data
      <<~CONF_DATA.chomp
        configurations {
            mockitoAgent {
                transitive = false
            }
        }
      CONF_DATA
    end

    def libs_data
      <<~LIBS_DATA.chomp
        implementation 'com.me.libs:libext:1.0.0'
            mockitoAgent 'org.mockito:mockito-core:5.21.0'
      LIBS_DATA
    end

    def repo_data
      <<~REPO_DATA.chomp
        mavenCentral()
            mavenLocal()
      REPO_DATA
    end

    def test_data
      <<~TEST_DATA.chomp
        testImplementation('org.junit.jupiter:junit-jupiter:6.0.3')
            testImplementation('org.hamcrest:hamcrest:3.0')
            testImplementation('org.mockito:mockito-core:5.21.0')
      TEST_DATA
    end

    def unit_data
      <<~UNIT_DATA.chomp
        useJUnitPlatform()
            jvmArgs(
                "-javaagent:${configurations.mockitoAgent.singleFile}",
                "-Xshare:off"
            )
            testLogging {
                showStandardStreams = true
            }
      UNIT_DATA
    end

    def fetch_data?
      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      path = Pathname.new(".").expand_path
      run_tools?(path, [tool])
    end

    def patch_build?
      file = Pathname.new("app/build.gradle").expand_path
      sub_map.all? { |search, replace| token_gsub?(file, search, replace) }
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

    def sub_map
      {
        "dependencies {" => "#{conf_data}\n\ndependencies {",
        "\n    implementation libs.guava" => "    #{libs_data}",
        "    mavenCentral()" => "    #{repo_data}",
        "    testImplementation libs.junit.jupiter\n" => "    #{test_data}",
        "    useJUnitPlatform()" => "    #{unit_data}"
      }
    end
  end
end
