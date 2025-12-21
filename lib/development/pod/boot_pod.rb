# frozen_string_literal: true

module Development
  # Provides boot-specific utilities implementation
  class BootPod < CorePod
    private

    # Class private methods
    include Hub

    def boot_data
      <<~BOOT_DATA
        endpoints.shutdown.enabled=true
        management.endpoint.shutdown.enabled=true
        management.endpoints.web.exposure.include=*
        logging.level.org.apache.tomcat.util.net.Acceptor=OFF
      BOOT_DATA
    end

    def fetch_data?
      tool1 = %w[curl https://start.spring.io/starter.tgz].tap { |t| append_options(t, sep: "-") }
      tool2 = %w[tar -xzvf -]
      path = Pathname.new(".").expand_path
      run_pipeline?(path, [tool1, tool2])
    end

    def patch_build?
      gb_file = Pathname.new("#{Development.pod_name}/build.gradle").expand_path
      gb_repo = "mavenCentral()\n    mavenLocal()"
      gb_task = "\ntasks.bootRun {\n\tignoreExitValue = true\n}\n"
      gb_deps = "dependencies {\n\timplementation 'com.me.libs:libext:1.0.0'"
      gb_test = "useJUnitPlatform()\n\ttestLogging {\n\t\tshowStandardStreams = true\n\t}"
      update_file?(gb_file, "a", gb_task) &&
        token_gsub?(gb_file, "dependencies {", gb_deps) &&
        token_gsub?(gb_file, "mavenCentral()", gb_repo) &&
        token_gsub?(gb_file, "useJUnitPlatform()", gb_test)
    end

    def patch_file?
      sb_file = Pathname.new("#{Development.pod_name}/src/main/resources/application.properties").expand_path
      update_file?(sb_file, "a", boot_data) && patch_build?
    end

    def patch_path?
      path = Pathname.new(Development.data_path).expand_path
      src1 = path.join("boot/main/greeting")
      src2 = path.join("boot/test/greeting")
      dest1 = Pathname.new("#{Development.pod_name}/src/main/java/com/me/demo").expand_path
      dest2 = Pathname.new("#{Development.pod_name}/src/test/java/com/me/demo").expand_path
      copy_item?(src1, dest1) && copy_item?(src2, dest2)
    end

    def run_deploy?
      tool = %w[gradle bootRun --console verbose]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
    end

    def run_update?
      tool = %w[gradle test --continuous --console verbose]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool])
    end

    def provide_options
      [{ "d" => "type=gradle-project" },
       { "d" => "dependencies=web,devtools,actuator" },
       { "d" => "baseDir=#{Development.pod_name}" },
       { "d" => "groupId=com.me" },
       { "d" => "javaVersion=25" },
       { "d" => "applicationName=App" },
       { "d" => "packageName=com.me.demo" }]
    end
  end
end
