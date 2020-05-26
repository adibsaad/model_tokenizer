# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'model_tokenizer/version'

Gem::Specification.new do |spec|
  spec.name          = "model_tokenizer"
  spec.version       = ModelTokenizer::VERSION
  spec.authors       = ["Adib Saad"]
  spec.email         = ["adib.saad@gmail.com"]
  spec.summary       = %q{Random token generator for Rails models}
  spec.homepage      = "https://github.com/adibsaad/model_tokenizer"
  spec.license       = "MIT"
  spec.description   = 
      %q{ModelTokenizer creates random tokens to be
        used as primary keys for ActiveRecord objects}

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_dependency("activerecord", "~> 4.0")
end
