# frozen_string_literal: true

require_relative "development/pod"
require_relative "development/pod/version"

def reload!(print: true)
  puts "Reloading..." if print
  root_dir = File.expand_path("..", __dir__ || Dir.pwd)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir["#{root_dir}/#{dir}/**/*.rb"].each do |file|
      load file
    end
  end
  true
end

# provides development-related utilities
module Development
end
