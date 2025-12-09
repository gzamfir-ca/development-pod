# frozen_string_literal: true

module Development
  # provides boot-specific implementation
  class BootPod < Pod
    GS_FILE = "settings.gradle"
    GB_FILE = "app/build.gradle"
    SB_FILE = "app/src/main/resources/application.properties"
    # class private methods
    def boot_data
      <<~MULTILINE_CONTENT
        endpoints.shutdown.enabled=true
        management.endpoint.shutdown.enabled=true
        management.endpoints.web.exposure.include=*
        logging.level.org.apache.tomcat.util.net.Acceptor=OFF
      MULTILINE_CONTENT
    end

    def fetch_data
      tool1 = %w[curl https://start.spring.io/starter.tgz].tap { |t| append_options(t, sep: "-") }
      tool2 = %w[tar -xzvf -]
      res_ok = system!(tool1, tool2)
      items = %w[.gitattributes .gitignore gradle gradlew gradlew.bat HELP.md settings.gradle]
      items.each do |item|
        res_ok = Development.move_item("./app/#{item}", ".") && res_ok
      end
      res_ok
    end

    def patch_data
      path = Pathname.new(Development.data_path).expand_path
      src_item1 = path.join("boot/main/greeting").to_s
      src_item2 = path.join("boot/test/greeting").to_s
      dest_item1 = "./app/src/main/java/com/me/demo"
      dest_item2 = "./app/src/test/java/com/me/demo"
      res_ok = Development.copy_item(src_item1, dest_item1)
      Development.copy_item(src_item2, dest_item2) && res_ok
    end

    def patch_file
      res_ok = write_file(SB_FILE, boot_data)
      write_file(GS_FILE, "include('app')") && res_ok
      write_file(GB_FILE, "\ntasks.bootRun {\n\tignoreExitValue = true\n}\n") && res_ok
    end

    def write_file(file, data)
      File.open(file, "a") do |f|
        f << data
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} p_file call failed: #{e.message}"
      false
    end

    def setup_core
      update_options && fetch_data && patch_file && patch_data
    end

    def provide_options
      [{ "d" => "type=gradle-project" },
       { "d" => "dependencies=web,devtools,actuator" },
       { "d" => "baseDir=app" },
       { "d" => "groupId=com.me" },
       { "d" => "javaVersion=25" },
       { "d" => "applicationName=App" },
       { "d" => "packageName=com.me.demo" }]
    end

    def update_options
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options(provide_options)
    end

    # class public methods
    def create
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      res_ok = setup_core && Development.append_timestamp
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end

    def deploy
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      tool = %w[gradle bootRun --console verbose]
      res_ok = system!(tool, nil)
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end

    def update
      unless Development.operational?
        msg = format(FAIL_MSG, self.class.name, __method__)
        puts "#{FAIL_COLOR}#{msg}#{BACK_COLOR}"
        return 1
      end

      tool = %w[gradle test --continuous --console verbose]
      res_ok = system!(tool, nil)
      msg = format(test_msg(res_ok), self.class.name, __method__)
      puts "#{test_color(res_ok)}#{msg}#{BACK_COLOR}"
      res_ok ? 0 : 1
    end
  end
end
