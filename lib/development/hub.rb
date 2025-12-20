# frozen_string_literal: true

module Development
  # provides pod helper methods
  module Hub
    def append_options(tool, sep: "--")
      Development.options.each do |item|
        item.each do |key, value|
          tool.push "#{sep}#{key}"
          tool.push value.to_s unless value.nil? || value.to_s.empty?
        end
      end
    end

    def copy_item?(src, dest)
      FileUtils.cp_r(src, dest, verbose: true, preserve: true)
      true
    rescue StandardError => e
      log_exception(__method__, "modifying #{dest} failed: ", e)
      false
    end

    def filter_file?(file, patterns)
      lines = File.readlines(file)
      lines.select! { |line| line.strip.start_with?(*patterns) }
      File.write(file, lines.join)
      true
    rescue StandardError => e
      log_exception(__method__, "modifying #{file} failed: ", e)
      false
    end

    def git_init?
      tool = %w[git init .]
      repo = Development.pod_name.to_s
      FileUtils.cd(repo, verbose: true) do
        Dir.exist?(".git") || system?(tool, nil)
      end
    rescue StandardError => e
      log_exception(__method__, "modifying #{repo} failed: ", e)
      false
    end

    def move_item?(src, dest)
      FileUtils.mv(src, dest, verbose: true, secure: true)
      true
    rescue StandardError => e
      log_exception(__method__, "modifying #{dest} failed: ", e)
      false
    end

    def run_pipeline?(path, tools)
      FileUtils.cd(path, verbose: true) do
        system?(tools[0], tools[1])
      end
    rescue StandardError => e
      log_exception(__method__, "executing #{tools} failed: ", e)
      false
    end

    def run_tools?(path, tools)
      FileUtils.cd(path, verbose: true) do
        tools.all? { |tool| system?(tool, nil) }
      end
    rescue StandardError => e
      log_exception(__method__, "executing #{tools} failed: ", e)
      false
    end

    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_path? && git_init?
    end

    def token_gsub?(file, original, replacement)
      content = File.read(file)
      File.write(file, content.gsub(original, replacement))
      true
    rescue StandardError => e
      log_exception(__method__, "modifying #{file} failed: ", e)
      false
    end

    def update_file?(file, mode, data)
      File.open(file, mode) { |f| f << data }
      true
    rescue StandardError => e
      log_exception(__method__, "modifying #{file} failed: ", e)
      false
    end

    def update_options?
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options?(provide_options)
    end

    private

    def log_exception(method_name, message, exp)
      puts "#{self.class.name}:#{method_name} #{message} #{exp.message}"
    end
  end
end
