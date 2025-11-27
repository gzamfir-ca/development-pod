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
      dest_dir1 = "./app/src/main/java/com/example/demo"
      dest_dir2 = "./app/src/test/java/com/example/demo"
      res_ok = copy_item(src_dir1, dest_dir1)
      copy_item(src_dir2, dest_dir2) && res_ok
    end

    # class public methods
    def create
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      res_ok = fetch_data
      res_ok = patch_data && res_ok
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      tool = %w[gradle bootRun --console verbose]
      res_ok = system!(tool)
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end

    def update
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      tool = %w[gradle test --continuous --console verbose]
      res_ok = system!(tool)
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end
  end
end
