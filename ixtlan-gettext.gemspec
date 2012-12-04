# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-gettext'
  s.version = '0.1.0'

  s.summary = ''
  s.description = ''
  s.homepage = 'https://github.com/mkristian/ixtlan-remote'

  s.authors = ['Kristian Meier']
  s.email = ['m.kristian@web.de']

  s.license = "AGPL-3"

  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*'] 
  s.files += Dir['agpl-3.0.txt']
  s.files += Dir['*.md']
  s.files += Dir['Gemfile']

  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_dependency 'ixtlan-remote', '~> 0.1'
  s.add_development_dependency 'rake', '= 0.9.2.2'
  s.add_development_dependency 'minitest', '3.3.0'
  s.add_development_dependency 'dm-sqlite-adapter', '1.2.0'
  s.add_development_dependency 'dm-migrations', '1.2.0'
end
