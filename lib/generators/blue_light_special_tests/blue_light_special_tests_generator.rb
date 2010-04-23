class BlueLightSpecialTestsGenerator < Rails::Generators::Base

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def blue_light_special_tests_generator
    empty_directory File.join("test", "integration")

    ["test/integration/facebook_test.rb",
     "test/integration/impersonation_test.rb",
     "test/integration/sign_in_test.rb",
     "test/integration/sign_out_test.rb",
     "test/integration/sign_up_test.rb",
     "test/integration/edit_profile_test.rb",
     "test/integration/password_reset_test.rb"].each do |file|
       copy_file file, file
     end
    
    readme "README"
  end

end
