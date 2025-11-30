# frozen_string_literal: true

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
rescue StandardError => e
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

def system!(args1, args2, print: true)
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
