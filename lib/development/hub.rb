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

    def copy_item?(src_item, dest_item)
      FileUtils.cp_r(src_item, dest_item, verbose: true, preserve: true)
      true
    rescue StandardError => e
      puts "#{name}:#{__method__} copying item failed: #{e.message}"
      false
    end

    def filter_file?(file, patterns)
      lines = File.readlines(file)
      lines.select! do |line|
        line.strip.start_with?(*patterns)
      end
      File.open(file, "w") { |f| f.puts lines }
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} file filtering failed: #{e.message}"
      false
    end

    def move_item?(src_item, dest_item)
      FileUtils.mv(src_item, dest_item, verbose: true, secure: true)
      true
    rescue StandardError => e
      puts "#{name}:#{__method__} moving item failed: #{e.message}"
      false
    end

    def run_pipeline?(path, tools)
      res_ok = true
      FileUtils.cd(path, verbose: true) do
        res_ok = system?(tools[0], tools[1]) && res_ok
      end && res_ok
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} running pipeline failed: #{e.message}"
      false
    end

    def run_tools?(path, tools)
      res_ok = true
      FileUtils.cd(path, verbose: true) do
        tools.each do |tool|
          res_ok = system?(tool, nil) && res_ok
        end
      end && res_ok
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} running tools failed: #{e.message}"
      false
    end

    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_path?
    end

    def token_gsub?(file, original, replacement)
      content = File.read(file)
      new_content = content.gsub(original, replacement)
      File.write(file, new_content)
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} substituting token failed: #{e.message}"
      false
    end

    def update_file?(file, mode, data)
      File.open(file, mode) do |f|
        f << data
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} file updating failed: #{e.message}"
      false
    end

    def update_options?
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options?(provide_options)
    end
  end
end
