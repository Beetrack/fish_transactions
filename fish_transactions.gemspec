$:.push File.expand_path("../lib", __FILE__)
require 'fish_transactions/version'

Gem::Specification.new do |spec|
  spec.name          = "fish_transactions"
  spec.version       = FishTransactions::VERSION
  spec.authors       = ["John Owen"]
  spec.email         = ["john.owen@beetrack.com"]

  spec.summary       = %q{Callbacks for Active Record transactions that can be used anywhere.}
  spec.description   = %q{Allows to pospose the execution of a code waiting for Active Record transactions, on commit, on rollback or both.}
  spec.homepage      = "https://github.com/Beetrack/fish_transactions"
  spec.license       = "MIT"

  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = Dir["{lib}/**/*", "MIT-LICENSE.txt", "Rakefile", "README.md"]
  spec.test_files    = Dir["{spec}/**/*"]
  #spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rdoc", "~> 3.12"
  spec.add_development_dependency 'simplecov', "~> 0.11"
  spec.add_development_dependency 'activerecord-nulldb-adapter', "~> 0.3"

  spec.add_runtime_dependency "activerecord", "~> 4.2"

end
