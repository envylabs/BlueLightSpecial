class BlueLightSpecialAdminGenerator < Rails::Generators::Base

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def blue_light_special_admin_generator
    empty_directory File.join("app", "controllers", "admin")
    copy_file "app/controllers/admin/admin_controller.rb", "app/controllers/admin/admin_controller.rb"
    copy_file "app/controllers/admin/users_controller.rb", "app/controllers/admin/users_controller.rb"

    empty_directory File.join("app", "views", "admin", "users")
    ["app/views/admin/users/_form.html.erb",
     "app/views/admin/users/edit.html.erb",
     "app/views/admin/users/index.html.erb",
     "app/views/admin/users/new.html.erb",
     "app/views/admin/users/show.html.erb"].each do |file|
      copy_file file, file
    end
    
    empty_directory File.join("test", "integration", "admin")
    copy_file "test/integration/admin/users_test.rb", "test/integration/admin/users_test.rb"      

    route "map.namespace :admin do |admin|\n    admin.resources :users\n  end"
    
    readme "README"
  end
  
end
