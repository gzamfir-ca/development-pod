# frozen_string_literal: true

require_relative "lib/development/pod/version"

Gem::Specification.new do |spec|
  spec.name = "development-pod"
  spec.version = Development::Pod::VERSION
  spec.authors = ["gzamfir-ca"]
  spec.email = ["gzamfir_ca@icloud.com"]

  spec.summary = "development pod"
  spec.description = "a development pod for various tools and utilities"
  spec.homepage = "https://github.com/gzamfir-ca/development-pod"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gzamfir-ca/development-pod"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .rubocop.yml .idea/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.7.2"
  spec.add_development_dependency "irb"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"

  spec.add_dependency "thor", "~> 1.4"
end
