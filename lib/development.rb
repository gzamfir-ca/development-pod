# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/pod/java_pod"
require_relative "development/pod/version"
require "pathname"
require "rubygems"
require "shellwords"
require "yaml"

# define helper methods
def load_file(file)
  load file
rescue StandardError => e
  puts "#{Object.name}:#{__method__} loading file failed: #{e.message}"
  nil
end

def load_yaml(file)
  YAML.safe_load_file(file, permitted_classes: [Time])
rescue StandardError => e
  puts "#{Object.name}:#{__method__} loading yaml failed: #{e.message}"
  nil
end

def shell_cmd(cmd)
  system("/bin/bash", "-c", cmd, exception: true)
  Process.last_status&.exitstatus
rescue SystemCallError => e
  puts "#{Object.name}:#{__method__} system call failed: #{e.message}"
  nil
end

# define system-wide utilities
def reload!(print: true)
  path = File.expand_path("..", __dir__ || Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir["#{path}/#{dir}/**/*.rb"].each do |file|
      puts "#{Object.name}:#{__method__} reloading: #{file}" if print
      load_file(file)
    end
  end
  true
end

def system!(*args, print: true)
  cmd = Shellwords.join(args)
  puts "#{Object.name}:#{__method__} executing: #{cmd}" if print
  shell_cmd(cmd)&.zero? || false
end

def upload!(file, print: true)
  puts "#{Object.name}:#{__method__} uploading: #{file}" if print
  load_yaml(file)
end

# provides development-related utilities
module Development
  CFG_NAME = "pod.yaml"
  DEV_ROOT = "Developer"
  SRC_FILE = "src.yaml"
  GEM_NAME = Gem.loaded_specs["development-pod"].name
  CFG_PATH = Pathname.new(Dir.pwd).join(CFG_NAME.to_s).expand_path.to_s
  DEV_PATH = Pathname.new(Dir.home).join(DEV_ROOT.to_s).expand_path.to_s

  def self.configured?
    File.exist?(CFG_NAME)
  end

  def self.data_path
    gem_spec = Gem::Specification.find_by_name(GEM_NAME)
    File.join(gem_spec.full_gem_path, "data")
  rescue StandardError => e
    puts "#{name}:#{__method__} system path failed: #{e.message}"
    "."
  end

  def self.operational?
    configured? && secured?
  end

  def self.options
    @profile["options"] || {}
  rescue NameError => e
    puts "#{name}:#{__method__} options not found: #{e.message}"
    {}
  end

  def self.protected?
    File.exist?(SRC_FILE)
  end

  def self.read_data(file)
    path = Pathname.new(data_path).expand_path
    path.join(file).read.strip
  rescue StandardError => e
    puts "#{name}:#{__method__} reading data failed: #{e.message}"
    ""
  end

  def self.runtime_class
    runtime_name = @profile["runtime"]
    return Pod if runtime_name.nil? || runtime_name.empty?

    Object.const_get("#{Development.name}::#{runtime_name.capitalize}Pod")
  rescue NameError => e
    puts "#{name}:#{__method__} runtime not found: #{e.message}"
    Pod
  end

  def self.runtime
    @runtime ||= runtime_class.new
  end

  def self.secured?
    File.expand_path(Dir.pwd).start_with?(DEV_PATH)
  end

  def self.setup
    @profile = upload!(CFG_PATH)
  end
end
