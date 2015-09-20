# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'pronto/fasterer/version'

Gem::Specification.new do |s|
  s.name = 'pronto-fasterer'
  s.version = Pronto::FastererVersion::VERSION
  s.platform = Gem::Platform::RUBY
  s.author = 'Mindaugas Mozūras'
  s.email = 'mindaugas.mozuras@gmail.com'
  s.homepage = 'http://github.org/mmozuras/pronto-fasterer'
  s.summary = 'Pronto runner for Fasterer, speed improvements suggester'

  s.required_rubygems_version = '>= 1.3.6'
  s.license = 'MIT'

  s.files = Dir.glob('{lib}/**/*') + %w(LICENSE README.md)
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'fasterer', '~> 0.1.11'
  s.add_runtime_dependency 'pronto', '~> 0.4.0'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its', '~> 1.0'
end
