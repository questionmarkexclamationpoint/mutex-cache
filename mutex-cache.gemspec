lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name           = 'mutex-cache'
  spec.version        = '1.0'
  spec.authors        = ['interrobang']
  spec.summary        = 'Similar to a mutex, but stores multiple locks simultaneously. Thread safe.'
  spec.license        = 'MIT'

  spec.files          = Dir.glob('lib/*')
  spec.require_paths  = ['lib']
end