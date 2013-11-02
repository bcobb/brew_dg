# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name            = "brew_dg"
  s.version         = "0.0.1"
  s.platform        = Gem::Platform::RUBY
  s.summary         = "Work with homebrew dependencies as graphs"

  s.license         = 'MIT'

  s.files           = Dir['{lib/**/*}'] + %w(README.md LICENSE)
  s.bindir          = 'bin'
  s.executables     = ['brew_dg']
  s.require_path    = 'lib'
  s.extra_rdoc_files = ['README.md']
  s.test_files      = Dir['spec/**/*_spec.rb']

  s.author          = 'Brian Cobb'
  s.email           = 'bcobb@uwalumni.com'
  s.homepage        = 'https://github.com/bcobb/brew_dg'

  s.add_runtime_dependency 'virtus'
  s.add_runtime_dependency 'plexus'
  s.add_runtime_dependency 'ruby-graphviz'

  s.add_development_dependency 'rspec'
end
