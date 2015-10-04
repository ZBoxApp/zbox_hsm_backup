# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zbox_hsm_backup/version'

Gem::Specification.new do |spec|
  spec.name          = "zbox_hsm_backup"
  spec.version       = ZboxHsmBackup::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@itlinux.cl"]

  spec.summary       = %q{Backups para ZBox}
  spec.description   = %q{Backups para HSM de ZBox}
  spec.homepage      = "https://github.com/ZBoxApp/zbox_hsm_backup"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'mail'
  spec.add_dependency 'parallel'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
