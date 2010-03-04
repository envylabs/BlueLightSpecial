class BlueLightSpecialTestsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("test", "unit")
      m.directory File.join("test", "functional")
      m.directory File.join("test", "integration")

      ["test/integration/facebook_test.rb",
       "test/integration/sign_in_test.rb",
       "test/integration/sign_out_test.rb",
       "test/integration/sign_up_test.rb",
       "test/integration/password_reset_test.rb"].each do |file|
        m.file file, file
       end
      
      m.readme "README"
    end
  end

end
