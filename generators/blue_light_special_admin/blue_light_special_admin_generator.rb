require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")

class BlueLightSpecialAdminGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("app", "controllers", "admin")
      m.file "app/controllers/admin/admin_controller.rb", "app/controllers/admin/admin_controller.rb"
      m.file "app/controllers/admin/users_controller.rb", "app/controllers/admin/users_controller.rb"

      m.directory File.join("app", "views", "admin", "users")
      ["app/views/admin/users/_form.html.erb",
       "app/views/admin/users/edit.html.erb",
       "app/views/admin/users/index.html.erb",
       "app/views/admin/users/new.html.erb",
       "app/views/admin/users/show.html.erb"].each do |file|
        m.file file, file
      end
      
      m.directory File.join("test", "integration", "admin")
      m.file "test/integration/admin/users_test.rb", "test/integration/admin/users_test.rb"      

      m.insert_into "config/routes.rb",
                    "map.namespace :admin do |admin|\n    admin.resources :users\n  end"
      
      m.readme "README"
    end
  end
  
end
