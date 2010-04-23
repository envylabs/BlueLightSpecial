class BlueLightSpecialGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end
  
  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
  
  def blue_light_special_generator
    empty_directory File.join("config", "initializers")
    copy_file "blue_light_special.rb",  "config/initializers/blue_light_special.rb"
    copy_file "blue_light_special.yml", "config/blue_light_special.yml"

    empty_directory File.join("app", "views", "layouts")
    copy_file "application.html.erb", "app/views/layouts/application.html.erb"

    empty_directory File.join("public", "stylesheets")
    copy_file "style.css", "public/stylesheets/style.css"

    copy_file "xd_receiver.html", "public/xd_receiver.html"
    copy_file "xd_receiver_ssl.html", "public/xd_receiver_ssl.html"

    inject_into_class "app/controllers/application_controller.rb",
                      ApplicationController,
                      "  include BlueLightSpecial::Authentication\n"

    user_model = "app/models/user.rb"
    if File.exists?(user_model)
      inject_into_class user_model, User, "  include BlueLightSpecial::User\n"
    else
      empty_directory File.join("app", "models")
      copy_file "user.rb", user_model
    end

    route "BlueLightSpecial::Routes.draw(map)"

    empty_directory File.join("test", "factories")
    copy_file "factories.rb", "test/factories/user.rb"

    migration_template "migrations/#{migration_source_name}.rb",
                       "db/migrate/blue_light_special_#{migration_target_name}"

    readme "README"
  end

  private

  def migration_source_name
    if ActiveRecord::Base.connection.table_exists?(:users)
      'update_users'
    else
      'create_users'
    end
  end

  def migration_target_name
    if upgrading_blue_light_special_again?
      "update_users_to_#{schema_version}"
    else
      'create_users'
    end
  end

  def schema_version
    IO.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')).strip.gsub(/[^\d]/, '_')
  end

  def upgrading_blue_light_special_again?
    ActiveRecord::Base.connection.table_exists?(:users)
  end

end
