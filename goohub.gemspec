# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
git = File.expand_path('../.git', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goohub/version'

Gem::Specification.new do |spec|
  spec.name          = "goohub"
  spec.version       = Goohub::VERSION
  spec.authors       = ["Nomura Laboratory"]
  spec.email         = ["nomura.laboratory@gmail.com"]

  spec.summary       = %q{Google calendar filter}
  spec.description   = %q{Google calendar filter}
  spec.homepage      = "https://github.com/nomlab/goohub"
  spec.license       = "MIT"

  spec.files         = if Dir.exist?(git)
                         `git ls-files -z`.split("\x0")
                       else
                         Dir['**/*']
                       end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "clian", "~> 0.3.0"
  spec.add_development_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
