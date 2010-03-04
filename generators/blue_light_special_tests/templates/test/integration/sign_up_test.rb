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
        sign_up(:email => 'invalidemail', :password_confirmation => '')
        assert_match /Email is invalid/, response.body
        assert_match /Password doesn't match confirmation/, response.body
      end
      
    end
    
    context 'with valid data' do
      
      should 'sign in the user' do
        sign_up(:email => 'bob@bob.bob', :password => 'password', :password_confirmation => 'password')
        assert controller.signed_in?
      end
    
      should 'see "Thanks for signing up with Twongo!"' do
        sign_up(:email => 'bob@bob.bob', :password => 'password', :password_confirmation => 'password')
        assert_match /Thanks for signing up with Twongo!/, response.body
      end
    
      should 'send a welcome email' do
        sign_up(:email => 'bob@bob.bob', :password => 'password', :password_confirmation => 'password')
        user = User.find_by_email('bob@bob.bob')
        Delayed::Job.work_off
        sent = ActionMailer::Base.deliveries.last
        assert_equal user.email, sent.recipients
        assert_match /welcome/i, sent.subject
      end
      
    end
    
    context 'with an email for an existing deleted user' do
      
      setup do
        @user = Factory(:user, :email => 'deleted@example.com')
        @user.destroy
      end
      
      should 'undelete the existing user' do
        sign_up(:email => 'deleted@example.com')
        @user.reload
        assert !@user.destroyed?
      end
      
      should 'sign in the user' do
        sign_up(:email => 'deleted@example.com', :password => 'password', :password_confirmation => 'password')
        assert controller.signed_in?
      end
    
      should 'see "Thanks for signing up with Twongo!"' do
        sign_up(:email => 'deleted@example.com', :password => 'password', :password_confirmation => 'password')
        assert_match /Thanks for signing up with Twongo!/, response.body
      end
    
      should 'send a welcome email' do
        sign_up(:email => 'deleted@example.com', :password => 'password', :password_confirmation => 'password')
        user = User.find_by_email('deleted@example.com')
        Delayed::Job.work_off
        sent = ActionMailer::Base.deliveries.last
        assert_equal user.email, sent.recipients
        assert_match /welcome/i, sent.subject
      end
      
    end
    
  end

end
