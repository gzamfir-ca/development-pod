# frozen_string_literal: true

module Development
  # provides boot-specific utilities implementation
  class BootPod < CorePod
    # class private methods
    include Hub

    def boot_data
      <<~MULTILINE_CONTENT
        endpoints.shutdown.enabled=true
        management.endpoint.shutdown.enabled=true
        management.endpoints.web.exposure.include=*
        logging.level.org.apache.tomcat.util.net.Acceptor=OFF
      MULTILINE_CONTENT
    end

    def fetch_data?
      tool1 = %w[curl https://start.spring.io/starter.tgz].tap { |t| append_options(t, sep: "-") }
      tool2 = %w[tar -xzvf -]
      run_pipeline?(".", [tool1, tool2])
    end

    def patch_file?
      sb_file = "#{Development.pod_name}/src/main/resources/application.properties"
      gb_file = "#{Development.pod_name}/build.gradle"
      gb_prop = "\ntasks.bootRun {\n\tignoreExitValue = true\n}\n"
      update_file?(sb_file, "a", boot_data) && update_file?(gb_file, "a", gb_prop)
    end

    def patch_path?
      path = Pathname.new(Development.data_path).expand_path
      src_item1 = path.join("boot/main/greeting").to_s
      dest_item1 = "#{Development.pod_name}/src/main/java/com/me/demo"
      src_item2 = path.join("boot/test/greeting").to_s
      dest_item2 = "#{Development.pod_name}/src/test/java/com/me/demo"
      copy_item?(src_item1, dest_item1) && copy_item?(src_item2, dest_item2)
    end

    def run_deploy?
      tool = %w[gradle bootRun --console verbose]
      run_tools?(Development.pod_name, [tool])
    end

    def run_update?
      tool = %w[gradle test --continuous --console verbose]
      run_tools?(Development.pod_name, [tool])
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
