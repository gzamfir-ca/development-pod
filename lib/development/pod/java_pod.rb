# frozen_string_literal: true

module Development
  # provides java specific implementation
  class JavaPod < Pod
    # class public methods
    def create
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      tool = %w[gradle init --console verbose].tap { |t| append_options(t) }
      res_ok = system!(tool)
      "#{self.class.name}:#{__method__} #{res_ok ? "succeeded!" : "failed!"}"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not allowed!" unless Development.operational?

      tool = %w[gradle run --console verbose]
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
