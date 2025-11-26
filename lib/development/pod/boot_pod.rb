# frozen_string_literal: true

module Development
  # provides boot-specific implementation
  class BootPod < Pod
    # class public methods
    def create
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      tool1 = %w[curl https://start.spring.io/starter.tgz].tap { |t| append_options(t, sep: "-") }
      tool2 = %w[tar -xzvf -]
      res_ok = system!(tool1, tool2)
      items = %w[.gitattributes .gitignore gradle gradlew gradlew.bat HELP.md settings.gradle]
      items.each do |item|
        res_ok = move_item("./app/#{item}", ".") && res_ok
      end
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
