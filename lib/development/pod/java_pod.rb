# frozen_string_literal: true

module Development
  # provides java specific implementation
  class JavaPod < Pod
    def create
      tool = %w[gradle init]
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "--#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
      toolset = [tool]
      all_ok = run_all(*toolset)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end

    def deploy
      tool = %w[gradle run]
      toolset = [tool]
      all_ok = run_all(*toolset)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end

    def update
      tool = %w[gradle test --continuous]
      toolset = [tool]
      all_ok = run_all(*toolset)
      "#{self.class.name}:#{__method__} #{all_ok ? "succeeded!" : "failed!"}"
    end
  end
end
