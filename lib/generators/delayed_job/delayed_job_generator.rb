class DelayedJobGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end
  
  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
  
  def delayed_job_generator
    copy_file 'script', 'script/delayed_job', :chmod => 0755
    migration_template "migration.rb", 'db/migrate/create_delayed_jobs'
  end
  
end
