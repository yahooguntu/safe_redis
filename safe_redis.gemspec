# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safe_redis'

Gem::Specification.new do |spec|
  spec.name          = 'safe_redis'
  spec.version       = '0.1.0'
  spec.authors       = ['Mitch Birti']
  spec.email         = ['yahooguntu@gmail.com']

  spec.summary       = %q{Redis wrapper to catch read failures so things don't fail when Redis is down.}
  spec.description   = %q{If an operation fails, SafeRedis responds as if the key doesn't exist.}
  spec.homepage      = 'https://github.com/yahooguntu/safe_redis'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"
  spec.add_development_dependency "fakeredis"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
