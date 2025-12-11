# frozen_string_literal: true

module Development
  # provides vite-specific implementation
  class VitePod < CorePod
    # class private methods
    include Hub

    def fetch_data?
      tool = %W[npm create vite@latest #{Development.pod_name} --].tap { |t| append_options(t) }
      run_tools?(".", [tool])
    end

    def patch_data?
      true
    end

    def patch_file?
      true
    end

    def provide_options
      [{ "template" => "react-ts" }, { "no-interactive" => nil }]
    end

    def run_deploy?
      tool1 = %w[npm run build]
      tool2 = %w[npm run preview]
      run_tools?(Development.pod_name, [tool1, tool2])
    end

    def run_update?
      tool1 = %w[npm install]
      tool2 = %w[npm run dev]
      run_tools?(Development.pod_name, [tool1, tool2])
    end
  end
end
