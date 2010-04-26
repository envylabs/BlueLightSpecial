require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  context 'Signing up as a new user' do
    
    setup do
      ActionMailer::Base.deliveries.clear
    end

    teardown do
      ActionMailer::Base.deliveries.clear
    end
    
    context 'with invalid data' do
      
      should 'show error messages' do
        sign_up(:email => 'invalidemail', :password_confirmation => '', :first_name => '', :last_name => '')
        assert_match /Email is invalid/, response.body
        assert_match /First name.*blank/, response.body
        assert_match /Last name.*blank/, response.body
        assert_match /Password doesn't match confirmation/, response.body
      end
      
    end
    
    context 'with valid data' do
      
      should 'sign in the user' do
        sign_up(:email => 'bob@bob.bob', :password => 'password', :password_confirmation => 'password')
        assert controller.signed_in?
      end
    
      should 'send a welcome email' do
        sign_up(:email => 'bob@bob.bob', :password => 'password', :password_confirmation => 'password')
        user = User.find_by_email('bob@bob.bob')
        Delayed::Worker.new.work_off
        sent = ActionMailer::Base.deliveries.last
        assert_equal user.email, sent[:to].to_s
        assert_match /welcome/i, sent[:subject].to_s
      end
      
    end
    
  end

end
