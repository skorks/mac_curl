# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mac_curl','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'mac_curl'
  s.version = MacCurl::VERSION
  s.author = 'Alan Skorkin'
  s.email = 'alan@skorks.com'
  s.homepage = 'http://skorks.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A CURL like script to do MAC signed requests to urls'

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('escort')
  s.add_runtime_dependency('faraday')
  s.add_runtime_dependency('faraday_middleware')
  s.add_runtime_dependency('mach')
  s.add_runtime_dependency('playup_helpers')

  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables << 'mac_curl'
  s.require_paths << 'lib'
  s.bindir = 'bin'
end
