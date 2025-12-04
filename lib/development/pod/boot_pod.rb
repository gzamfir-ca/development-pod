# frozen_string_literal: true

module Development
  # provides boot-specific implementation
  class BootPod < Pod
    # class private methods
    def fetch_data
      tool1 = %w[curl https://start.spring.io/starter.tgz].tap { |t| append_options(t, sep: "-") }
      tool2 = %w[tar -xzvf -]
      res_ok = system!(tool1, tool2)
      items = %w[.gitattributes .gitignore gradle gradlew gradlew.bat HELP.md settings.gradle]
      items.each do |item|
        res_ok = move_item("./app/#{item}", ".") && res_ok
      end
      res_ok
    end

    def patch_data
      path = Pathname.new(Development.data_path).expand_path
      src_dir1 = path.join("boot/main/greeting").to_s
      src_dir2 = path.join("boot/test/greeting").to_s
      dest_dir1 = "./app/src/main/java/com/me/demo"
      dest_dir2 = "./app/src/test/java/com/me/demo"
      res_ok = copy_item(src_dir1, dest_dir1)
      copy_item(src_dir2, dest_dir2) && res_ok
    end

    def patch_file
      File.open("settings.gradle", "a") do |f|
        f.puts "include('app')"
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} p_file call failed: #{e.message}"
      false
    end

    def setup_core
      update_options && fetch_data && patch_data && patch_file
    end

    def provide_options
      [{ "d" => "type=gradle-project" },
       { "d" => "dependencies=web,devtools" },
       { "d" => "baseDir=app" },
       { "d" => "groupId=com.me" },
       { "d" => "javaVersion=25" },
       { "d" => "applicationName=App" },
       { "d" => "packageName=com.me.demo" }]
    end

    def update_options
      return true if Development.item?(Development::OPT_NAME)

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
