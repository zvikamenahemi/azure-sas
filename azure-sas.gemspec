$:.unshift File.expand_path('../lib', __FILE__)
require 'azure/sas'

Gem::Specification.new do |spec|
  spec.name          = 'azure-sas'
  spec.version       = Azure::SAS::VERSION
  spec.authors       = ['Michael Lutsiuk']
  spec.email         = ['michael.lutsiuk@gmail.com']
  spec.summary       = 'Azure Shared Access Signature generation'
  spec.description   = 'Implements the generation of Azure Shared Access Signature (SAS)'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_dependency 'azure', '~> 0.7'
  spec.add_dependency 'addressable', '~> 2.3'
end
