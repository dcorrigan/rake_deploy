Gem::Specification.new do |s|
  s.name        = 'rake_deploy'
  s.version     = '0.0.1'
  s.date        = '2017-05-25'
  s.summary     = "Rake tasks for static site deployment"
  s.description = "Configurable rake tasks for deploying static content via rsync"
  s.authors     = ["Dan Corrigan"]
  s.email       = 'df.corrigan@gmail.com'
  s.files       = ['lib/rake_deploy.rb']
  s.license       = 'MIT'
  s.homepage    = 'https://github.com/dcorrigan/rake_deploy'
  s.add_development_dependency('minitest')
  s.add_runtime_dependency('rake')
end
