require 'rake'
require 'rake/testtask'

task :default => [:test]

desc 'Test the simple_enum plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end
