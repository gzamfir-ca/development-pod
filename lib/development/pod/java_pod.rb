# frozen_string_literal: true

module Development
  # provides java specific implementation
  class JavaPod < Pod
    def create
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      tool = %w[gradle init].tap { |t| append_options(t) }
      all_ok = run_all(tool)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end

    def deploy
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      tool = %w[gradle run]
      all_ok = run_all(tool)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end

    def update
      return "#{self.class.name}:#{__method__} not configured!" unless Development.configured?

      tool = %w[gradle test --continuous]
      all_ok = run_all(tool)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end
  end
end
