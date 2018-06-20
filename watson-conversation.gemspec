# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watson/conversation/version'

Gem::Specification.new do |spec|
  spec.name          = "watson-conversation"
  spec.version       = Watson::Conversation::VERSION
  spec.authors       = ["alpha.netzilla"]
  spec.email         = ["alpha.netzilla@gmail.com"]

  spec.summary       = %q{Client library to use the IBM Watson Conversation service}
  spec.description   = %q{Client library to use the IBM Watson Conversation service}
  spec.homepage      = "https://github.com/alpha-netzilla/watson-conversation.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rest-client", "~> 2.0"
  spec.add_development_dependency "json", "~> 2.0"
  spec.add_development_dependency "redis", "~> 3.3"

  spec.post_install_message = <<-MESSAGE
   ! The 'watson-conversation' gem has been deprecated and has been replaced by 'watson-assistant'.
   ! See: https://rubygems.org/gems/watson-assistant
   ! And: https://github.com/alpha-netzilla/watson-assistant
  MESSAGE
end
