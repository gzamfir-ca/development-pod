# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/pod/boot_pod"
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

def system!(args1, args2 = nil, print: true)
  cmd1 = Shellwords.join(args1)
  cmd2 = Shellwords.join(args2) unless args2.nil? || args2.empty?
  full_cmd = cmd2 ? "#{cmd1} | #{cmd2}" : cmd1
  puts "#{Object.name}:#{__method__} executing: #{full_cmd}" if print
  shell_cmd(full_cmd)&.zero? || false
end

def upload!(file, print: true)
  puts "#{Object.name}:#{__method__} uploading: #{file}" if print
  load_yaml(file)
end

# provides development-related utilities
module Development
  DEV_ROOT = "Developer"
  CFG_FILE = "pod.yml"
  SRC_FILE = "src.yml"
  OPT_NAME = "options"
  RUN_TIME = "runtime"
  GEM_DATA = "data"
  POD_NAME = "Pod"
  GEM_NAME = Gem.loaded_specs["development-pod"].name
  CFG_PATH = Pathname.new(Dir.pwd).join(self::CFG_FILE).expand_path.to_s
  DEV_PATH = Pathname.new(Dir.home).join(self::DEV_ROOT).expand_path.to_s

  # module private methods
  def self.configured?
    File.exist?(self::CFG_FILE)
  end

  def self.protected?
    File.exist?(self::SRC_FILE)
  end

  def self.runtime_class
    runtime_name = @profile[self::RUN_TIME]
    return Pod if runtime_name.nil? || runtime_name.empty?

    Object.const_get("#{Development.name}::#{runtime_name.capitalize}#{self::POD_NAME}")
  rescue NameError => e
    puts "#{name}:#{__method__} runtime not found: #{e.message}"
    Pod
  end

  def self.secured?
    File.expand_path(Dir.pwd).start_with?(self::DEV_PATH)
  end

  # module public methods
  def self.data_path
    gem_spec = Gem::Specification.find_by_name(self::GEM_NAME)
    File.join(gem_spec.full_gem_path, self::GEM_DATA)
  rescue StandardError => e
    puts "#{name}:#{__method__} system path failed: #{e.message}"
    "."
  end

  def self.operational?
    configured? && secured? && !protected?
  end

  def self.options
    @profile[self::OPT_NAME] || {}
  rescue NameError => e
    puts "#{name}:#{__method__} options not found: #{e.message}"
    {}
  end

  def self.read_data(file)
    path = Pathname.new(data_path).expand_path
    path.join(file).read.strip
  rescue StandardError => e
    puts "#{name}:#{__method__} reading data failed: #{e.message}"
    ""
  end

  def self.runtime
    @runtime ||= runtime_class.new
  end

  def self.setup
    @profile = upload!(self::CFG_PATH)
  end
end
