# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'act/version'

Gem::Specification.new do |spec|
  spec.name          = "act"
  spec.version       = Act::VERSION
  spec.authors       = ["Fabio Pelosin"]
  spec.email         = ["fabiopelosin@gmail.com"]
  spec.summary       = %q{Act, the command line tool to act on files.}
  spec.homepage      = "https://github.com/irrationalfab/act"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "claide", "~> 0.5"
  spec.add_runtime_dependency "colored", "~> 1.2"
  spec.add_runtime_dependency "rouge", '~> 1.7'
  spec.add_runtime_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
