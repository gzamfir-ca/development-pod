# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/pod/java_pod"
require_relative "development/pod/version"
require "pathname"
require "shellwords"
require "yaml"

# define helper methods
def load_file(file)
  load file
rescue LoadError => e
  puts "loading file failed: #{e.message}"
  nil
rescue SyntaxError => e
  puts "loading file failed: #{e.message}"
  nil
rescue StandardError => e
  puts "loading file failed: #{e.message}"
  nil
end

def load_yaml(file)
  YAML.safe_load_file(file, permitted_classes: [Time])
rescue Psych::SyntaxError => e
  puts "loading yaml failed: #{e.message}"
  nil
rescue Psych::DisallowedClass => e
  puts "loading yaml failed: #{e.message}"
  nil
rescue StandardError => e
  puts "loading yaml failed: #{e.message}"
  nil
end

def shell_cmd(cmd)
  system("/bin/bash", "-c", cmd, exception: true)
rescue RuntimeError => e
  puts "command run failed: #{e.message}"
  nil
rescue SystemCallError => e
  puts "system call failed: #{e.message}"
  nil
end

# define system-wide utilities
def reload!(print: true)
  root_dir = File.expand_path("..", Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir["#{root_dir}/#{dir}/**/*.rb"].each do |file|
      puts "reloading: #{file}" if print
      load_file(file)
    end
  end
  true
end

def system!(*args, print: true)
  cmd = Shellwords.join(args)
  puts "executing: #{cmd}" if print
  shell_cmd(cmd)
end

def upload!(file, print: true)
  puts "uploading: #{file}" if print
  load_yaml(file)
end

# provides development-related utilities
module Development
  CONF_PATH = Pathname.new(Dir.pwd).join("./pod.yaml").expand_path.to_s

  def self.setup
    @profile = upload!(CONF_PATH, print: false)
  end

  def self.runtime_class
    runtime_name = @profile["runtime"]
    return Pod if runtime_name.nil? || runtime_name.empty?

    Object.const_get("#{Development.name}::#{runtime_name.capitalize}Pod")
  rescue NameError => e
    puts "runtime not found: #{e.message}"
    Pod
  end

  def self.runtime
    @runtime ||= runtime_class.new
  end
end
