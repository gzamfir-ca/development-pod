# frozen_string_literal: true

module Development
  # Provides vite-specific utilities implementation
  class VitePod < CorePod
    private

    # Class private methods
    include Hub

    def fetch_data?
      tool = %W[npm create vite@latest #{Development.pod_name} --].tap { |t| append_options(t) }
      path = Pathname.new(".").expand_path
      run_tools?(path, [tool])
    end

    def patch_file?
      vt_file = Pathname.new("#{Development.pod_name}/vite.config.ts").expand_path
      vt_prop = "react()],\n  server: {\n    open: (process.env.BROWSER = \"/Applications/Google Chrome.app\"),\n  },"
      token_gsub?(vt_file, "react()],", vt_prop)
    end

    def patch_path?
      true
    end

    def provide_options
      [{ "template" => "react-ts" }, { "no-interactive" => nil }]
    end

    def run_deploy?
      tool1 = %w[npm run build]
      tool2 = %w[npm run preview]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool1, tool2])
    end

    def run_update?
      tool1 = %w[npm install]
      tool2 = %w[npm run dev]
      path = Pathname.new(Development.pod_name).expand_path
      run_tools?(path, [tool1, tool2])
    end
  end
end
