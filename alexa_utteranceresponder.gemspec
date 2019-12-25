Gem::Specification.new do |s|
  s.name = 'alexa_utteranceresponder'
  s.version = '0.2.0'
  s.summary = 'Checks an utterance against an invocation keyword from the available skills and returns an Alexa formatted response to be passed to the skill\'s endpoint service.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/alexa_utteranceresponder.rb']
  s.add_runtime_dependency('askio', '~> 0.2', '>=0.2.0')
  s.add_runtime_dependency('alexa_modelbuilder', '~> 0.5', '>=0.5.2')
  s.signing_key = '../privatekeys/alexa_utteranceresponder.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/alexa_utteranceresponder'
end
