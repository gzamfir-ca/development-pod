# frozen_string_literal: true

require_relative "development/cli"
require_relative "development/pod"
require_relative "development/sys"
require_relative "development/pod/boot_pod"
require_relative "development/pod/java_pod"
require_relative "development/pod/ruby_pod"
require_relative "development/pod/version"
require_relative "development/pod/vite_pod"

require "pathname"
require "rubygems"

# provides development-related utilities
module Development
  DEV_ROOT = "Developer"
  CFG_FILE = "pod.yml"
  SRC_FILE = "src.yml"
  OPT_NAME = "options"
  RUN_TIME = "runtime"
  TOP_TIME = "created_at"
  TOP_USER = "updated_by"
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
  def self.append_timestamp
    @profile[self::TOP_TIME] = Time.now
    retain!(self::CFG_PATH, @profile)
  end

  def self.data_path
    gem_spec = Gem::Specification.find_by_name(self::GEM_NAME)
    File.join(gem_spec.full_gem_path, self::GEM_DATA)
  rescue StandardError => e
    puts "#{name}:#{__method__} system path failed: #{e.message}"
    "."
  end

  def self.item?(item)
    @profile.to_hash.key?(item)
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

  def self.remove_timestamp
    @profile.delete(self::TOP_TIME)
    retain!(self::CFG_PATH, @profile)
  end

  def self.runtime
    @runtime ||= runtime_class.new
  end

  def self.setup
    @profile = upload!(self::CFG_PATH)
  end

  def self.update_options(data)
    @profile[self::OPT_NAME] = data
    @profile[self::TOP_USER] = "#{name}:#{__method__}"
    retain!(self::CFG_PATH, @profile)
  end
end
