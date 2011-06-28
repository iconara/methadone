# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

require 'methadone/version'


Gem::Specification.new do |s|
  s.name        = 'methadone'
  s.version     = Methadone::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Theo Hultberg']
  s.email       = ['theo@iconara.net']
  s.homepage    = "http://github.com/iconara/methadone"
  s.summary     = %q{Methadone is a dependency injection framework for Ruby}
  s.description = %q{}

  s.rubyforge_project = 'methadone'

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
