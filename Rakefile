begin
  require 'rcov/rcovtask'
rescue LoadError
  require 'rubygems'
  require 'rcov/rcovtask'
end

require 'rake/testtask'

namespace :coverage do
  desc "Delete aggregate coverage data."
  task(:clean) { rm_f "coverage.data" }
end

desc 'Report code coverage with RCov'
Rcov::RcovTask.new(:coverage) do |t|
  t.libs << "test"
  t.test_files = ["test/interfacer.rb"]
  t.output_dir = "test/coverage/"
  t.verbose = true
  t.rcov_opts << '--aggregate coverage.data'
end
task :coverage => ['coverage:clean']

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = ['test/interfacer.rb']
  t.verbose = true
end

