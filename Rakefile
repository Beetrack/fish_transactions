require "bundler/gem_tasks"
require 'rdoc/task'
task :default => :spec

desc 'Generate documentation for FishTransactions.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Fish Transactions'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.main = 'README.md'
end