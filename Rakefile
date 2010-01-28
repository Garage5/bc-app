# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end

namespace :test do
  Rake::TestTask.new(:features => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/features/**/*.rb'
    t.verbose = true
  end
end