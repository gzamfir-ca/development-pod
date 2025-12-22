# frozen_string_literal: true

module Development
  # Provides generic utilities implementation
  class CorePod < Pod
    # Class public methods
    def create
      execute_task(__method__) { Development.inactive? && setup_core? && Development.append_timestamp? }
    end

    def deploy
      execute_task(__method__) { run_deploy? }
    end

    def update
      execute_task(__method__) { run_update? }
    end
  end
end
