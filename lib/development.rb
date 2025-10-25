# frozen_string_literal: true

require_relative "development/pod"
require_relative "development/pod/version"

def reload!(print: false)
  root_dir = File.expand_path("..", __dir__ || Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir["#{root_dir}/#{dir}/**/*.rb"].each do |file|
      next if file.include?("version")

      puts "reloading: #{file}" if print
      load file
    end
  end
  true
end

def system!(*args)
  system("/bin/bash", "-c", *args) || raise("command failed: #{args.join(" ")}")
end

# provides development-related utilities
module Development
end
