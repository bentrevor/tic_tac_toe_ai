# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tic_tac_toe_ai/version'

Gem::Specification.new do |spec|
  spec.name          = "tic_tac_toe_ai"
  spec.version       = TicTacToeAi::VERSION
  spec.authors       = ["Ben Trevor"]
  spec.email         = ["benjamin.trevor@gmail.com"]
  spec.description   = %q{This is a tic-tac-toe ai that uses the minimax algorithm.}
  spec.summary       = %q{UI-agnostic tic-tac-toe}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
