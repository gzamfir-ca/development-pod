# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/pod/version"
require "shellwords"

# define helper methods
def load_file(file, print)
  load file
rescue LoadError => e
  puts "reloading failed: #{e.message}" if print
rescue SyntaxError => e
  puts "reloading failed: #{e.message}" if print
rescue StandardError => e
  puts "reloading failed: #{e.message}" if print
end

# define system-wide utilities
def reload!(print: true)
  root_dir = File.expand_path("..", __dir__ || Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir["#{root_dir}/#{dir}/**/*.rb"].each do |file|
      next if file.include?("version")

      puts "reloading: #{file}" if print
      load_file(file, print)
    end
  end
  true
end

def system!(*args, print: true)
  command = Shellwords.join(args)
  system("/bin/bash", "-c", command, exception: true)
rescue RuntimeError => e
  puts "command run failed: #{e.message}" if print
rescue SystemCallError => e
  puts "system call failed: #{e.message}" if print
end

# provides development-related utilities
module Development
end
