require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "blue_light_special"
    gem.summary     = %Q{Rails authentication by email and password}
    gem.description = %Q{Rails authentication by email and password with integrated dependencies to MadMimi. Also provides administrative user impersonation.}
    gem.email       = "nate@envylabs.com"
    gem.homepage    = "http://github.com/envylabs/blue_light_special"
    gem.authors     = ["Nathaniel Bibler"]
    gem.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
    
    gem.add_dependency "facebooker", '=1.0.62'
    gem.add_dependency "delayed_job", '=1.8.4'
    gem.add_dependency "mad_mimi_mailer", '=0.0.7'
    
    gem.add_development_dependency "shoulda", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

namespace :test do
  Rake::TestTask.new(:basic => ["check_dependencies",
                                "generator:cleanup",
                                "generator:blue_light_special",
                                "generator:blue_light_special_tests"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/{controllers,models}/*_test.rb"
    task.verbose = false
  end
end

generators = %w(blue_light_special blue_light_special_tests)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["test/rails_root/db/**/*"].each do |each|
      FileUtils.rm_rf(each)
    end
    
    FileUtils.rm_rf("test/rails_root/vendor/plugins/blue_light_special")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    blue_light_special_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s \"#{blue_light_special_root}\" test/rails_root/vendor/plugins/blue_light_special")
  end
  
  desc "Run the blue_light_special generator"
  task :blue_light_special do
    system "cd test/rails_root && ./script/generate blue_light_special -f && ./script/generate delayed_job && ./script/generate facebook && rake gems:unpack && rake db:migrate db:test:prepare"
  end

  desc "Run the blue_light_special tests generator"
  task :blue_light_special_tests do
    system "cd test/rails_root && ./script/generate blue_light_special_tests -f"
  end
  
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => ['test:basic']

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "BlueLightSpecial #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
