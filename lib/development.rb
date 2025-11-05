# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/pod/version"
require "shellwords"
require "yaml"

# define helper methods
def load_file(file, print)
  load file
rescue LoadError => e
  puts "loading file failed: #{e.message}" if print
  nil
rescue SyntaxError => e
  puts "loading file failed: #{e.message}" if print
  nil
rescue StandardError => e
  puts "loading file failed: #{e.message}" if print
  nil
end

def load_yaml(file, print)
  YAML.safe_load_file(file, permitted_classes: [Time])
rescue Psych::SyntaxError => e
  puts "loading yaml failed: #{e.message}" if print
  nil
rescue Psych::DisallowedClass => e
  puts "loading yaml failed: #{e.message}" if print
  nil
rescue StandardError => e
  puts "loading yaml failed: #{e.message}" if print
  nil
end

def shell_cmd(cmd, print)
  system("/bin/bash", "-c", cmd, exception: true)
rescue RuntimeError => e
  puts "command run failed: #{e.message}" if print
  nil
rescue SystemCallError => e
  puts "system call failed: #{e.message}" if print
  nil
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
  cmd = Shellwords.join(args)
  puts "executing: #{cmd}" if print
  shell_cmd(cmd, print: print)
end

def upload!(file, print: true)
  puts "uploading: #{file}" if print
  load_yaml(file, print)
end

# provides development-related utilities
module Development
end
