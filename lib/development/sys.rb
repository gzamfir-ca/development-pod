# frozen_string_literal: true

# Provides top helper methods
def load_file(file)
  load file
rescue StandardError => e
  puts "#{Object.name}:#{__method__} loading file failed: #{e.message}"
  false
end

def load_yaml(file)
  YAML.safe_load_file(file, permitted_classes: [Time])
rescue StandardError => e
  puts "#{Object.name}:#{__method__} loading yaml failed: #{e.message}"
  nil
end

def save_yaml(file, data)
  yaml_str = data.to_yaml
  File.write(file, yaml_str)
  true
rescue StandardError => e
  puts "#{Object.name}:#{__method__} saving yaml failed: #{e.message}"
  false
end

def shell_cmd(cmd)
  system("/bin/bash", "-c", cmd, exception: true)
  0
rescue StandardError => e
  puts "#{Object.name}:#{__method__} system call failed: #{e.message}"
  Process.last_status.exitstatus
end

# Define system-wide utilities
def reload?(print: true)
  path = File.expand_path("../..", __dir__ || Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.all? do |dir|
    Dir["#{path}/#{dir}/**/*.rb"].all? do |file|
      puts "#{Object.name}:#{__method__} reloading: #{file}" if print
      load_file(file)
    end
  end
end

def retain?(file, data, print: true)
  puts "#{Object.name}:#{__method__} retaining: #{data}" if print
  save_yaml(file, data)
end

def system?(args1, args2, print: true)
  cmd1 = args1.shelljoin
  cmd2 = args2&.shelljoin unless args2.to_a.empty?
  full_cmd = cmd2 ? "#{cmd1} | #{cmd2}" : cmd1
  puts "#{Object.name}:#{__method__} executing: #{full_cmd}" if print
  shell_cmd(full_cmd).zero? || false
end

def upload!(file, print: true)
  puts "#{Object.name}:#{__method__} uploading: #{file}" if print
  load_yaml(file)
end
