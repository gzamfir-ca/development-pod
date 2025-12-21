# frozen_string_literal: true

# Provides development-related utilities
module Development
  DEV_ROOT = "Developer"
  CFG_FILE = "pod.yml"
  SRC_FILE = "src.yml"
  OPT_NAME = "options"
  RUN_TIME = "runtime"
  POD_NAME = "podname"
  TOP_TIME = "created_at"
  TOP_USER = "created_by"
  GEM_DATA = "data"
  POD_TYPE = "Pod"
  GEM_NAME = Gem.loaded_specs["development-pod"].name
  CFG_PATH = Pathname.new(Dir.pwd).join(CFG_FILE).expand_path.to_s
  DEV_PATH = Pathname.new(Dir.home).join(DEV_ROOT).expand_path.to_s

  # Module public methods
  def self.append_timestamp?
    @profile[TOP_TIME] = Time.now
    retain?(CFG_PATH, @profile)
  end

  def self.data_path
    gem_spec = Gem::Specification.find_by_name(GEM_NAME)
    path = File.join(gem_spec.full_gem_path, GEM_DATA)
  rescue StandardError => e
    log_exception(__method__, "preparing #{path} failed: ", e)
    "."
  end

  def self.entry?(entry)
    @profile.to_hash.key?(entry)
  end

  def self.inactive?
    !Dir.exist?(pod_name)
  end

  def self.operational?
    secured? && File.exist?(CFG_FILE) && !File.exist?(SRC_FILE)
  end

  def self.options
    opts = @profile[OPT_NAME] || []
  rescue NameError => e
    log_exception(__method__, "preparing #{opts} failed: ", e)
    []
  end

  def self.pod_name
    @profile[POD_NAME].to_s.strip.gsub(/[^0-9A-Za-z.-]/, "_")
  end

  def self.remove_timestamp?
    @profile.delete(TOP_TIME)
    retain_profile?
  end

  def self.runtime
    @runtime ||= runtime_class.new
  end

  def self.setup
    @profile = upload!(CFG_PATH)
  end

  def self.update_options?(data)
    @profile[OPT_NAME] = data
    @profile[TOP_USER] = "#{name}:#{__method__}"
    retain_profile?
  end

  # Module private methods
  def self.log_exception(method_name, message, exp)
    puts "#{name}:#{method_name} #{message} #{exp.message}"
  end

  def self.retain_profile?
    retain?(CFG_PATH, @profile)
  end

  def self.runtime_class
    runtime_name = @profile[RUN_TIME]
    return Pod if runtime_name.nil? || runtime_name.empty?

    pith = Object.const_get("#{Development.name}::#{runtime_name.capitalize}#{POD_TYPE}")
  rescue NameError => e
    log_exception(__method__, "preparing #{pith} failed: ", e)
    Pod
  end

  def self.secured?
    File.expand_path(Dir.pwd).start_with?(DEV_PATH)
  end

  private_class_method(:log_exception, :retain_profile?, :runtime_class, :secured?)
end
