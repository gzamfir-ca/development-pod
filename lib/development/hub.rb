# frozen_string_literal: true

module Development
  # provides pod helper methods
  module Hub
    def run_tools?(path, tools)
      res_ok = true
      FileUtils.cd(path, verbose: true) do
        tools.each do |tool|
          res_ok = system?(tool, nil) && res_ok
        end
      end && res_ok
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} runtime call failed: #{e.message}"
      false
    end

    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_data?
    end

    def token_gsub?(file, original, replacement)
      content = File.read(file)
      new_content = content.gsub(original, replacement)
      File.write(file, new_content)
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} writing token failed: #{e.message}"
      false
    end

    def update_file?(file, mode, data)
      File.open(file, mode) do |f|
        f << data
      end
      true
    rescue StandardError => e
      puts "#{self.class.name}:#{__method__} file writing failed: #{e.message}"
      false
    end

    def update_options?
      return true if Development.entry?(Development::OPT_NAME)

      Development.update_options?(provide_options)
    end
  end
end
