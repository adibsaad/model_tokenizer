# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'model_tokenizer/version'

Gem::Specification.new do |spec|
  spec.name          = "model_tokenizer"
  spec.version       = ModelTokenizer::VERSION
  spec.authors       = ["Adib Saad"]
  spec.email         = ["adib.saad@gmail.com"]
  spec.summary       = %q{Random token generator for ActiveRecord objects}
  spec.homepage      = "http://rubygems.org/gems/model_tokenizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "activerecord", "~> 4.0.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "minitest"
end
