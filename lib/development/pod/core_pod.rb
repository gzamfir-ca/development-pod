# frozen_string_literal: true

module Development
  # Provides generic utilities implementation
  class CorePod < Pod
    # Class public methods
    def create
      execute_task(__method__) do
        if Development.inactive?
          setup_core? && Development.append_timestamp?
        else
          false
        end
      end
    end

    def deploy
      execute_task(__method__) do
        run_deploy?
      end
    end

    def update
      execute_task(__method__) do
        run_update?
      end
    end
  end
end
