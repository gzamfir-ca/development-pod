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
      system!(*tool)
      "#{self.class.name}:#{__method__} completed!"
    end

    def deploy
      tool = %w[gradle run]
      system!(*tool)
      "#{self.class.name}:#{__method__} completed!"
    end

    def update
      tool = %w[gradle test --continuous]
      system!(*tool)
      "#{self.class.name}:#{__method__} completed!"
    end
  end
end
