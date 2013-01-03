# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mac_curl','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'mac_curl'
  s.version = MacCurl::VERSION
  s.author = 'Alan Skorkin'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/mac_curl
lib/mac_curl/version.rb
lib/mac_curl.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','mac_curl.rdoc']
  s.rdoc_options << '--title' << 'mac_curl' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'mac_curl'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('faraday')
  s.add_runtime_dependency('faraday_middleware')
  s.add_runtime_dependency('mach')
  s.add_runtime_dependency('playup_helpers')
end
