require 'test_helper'

class PasswordResetTest < ActionController::IntegrationTest
  
  context 'When requesting a password reset' do
    
    setup do
      ActionMailer::Base.deliveries.clear
    end
    
    teardown do
      ActionMailer::Base.deliveries.clear
    end
    
    context 'when not signed up' do
      
      should 'see "Unknown email"' do
        request_password_reset('unknown@bob.bob')
        assert_match(/Unknown email/, response.body)
      end
      
      should 'not send an email' do
        request_password_reset('unknown@bob.bob')
        assert ActionMailer::Base.deliveries.empty?
      end
      
    end
    
    context 'when signed up' do
      
      setup do
        @user = Factory(:user, :email => 'bob@bob.bob')
      end
      
      should 'see "instructions for changing your password"' do
        request_password_reset(@user.email)
        assert_match(/instructions for changing your password/, response.body)
      end
      
      should 'send a password reset email to the user' do
        request_password_reset(@user.email)
        @user.reload # catch updated confirmation token
        Delayed::Job.work_off
        assert !@user.password_reset_token.blank?
        assert_sent_email do |email|
          email.recipients =~ /#{Regexp.escape @user.email}/i &&
          email.subject =~ /password/i &&
          email.body[:url] =~ /#{Regexp.escape @user.password_reset_token}/
        end
      end
      
    end
    
  end
  
  context 'After requesting a password reset' do
    
    setup do
      ActionMailer::Base.deliveries.clear
      @user = Factory(:user, :email => 'bob@bob.bob')
    end
    
    teardown do
      ActionMailer::Base.deliveries.clear
    end
    
    context 'with failed password confirmation' do
      
      should 'see error messages' do
        request_password_reset('bob@bob.bob')
        @user.reload
        change_password(@user, :password => 'goodpassword', :confirm => 'badpassword')
        assert_match(/Password doesn't match confirmation/, response.body)
      end
      
      should 'not be signed in' do
        request_password_reset('bob@bob.bob')
        @user.reload
        change_password(@user, :password => 'goodpassword', :confirm => 'badpassword')
        assert !controller.signed_in?
      end
      
    end
    
    context 'with valid password and confirmation' do
      
      should 'be signed in' do
        request_password_reset('bob@bob.bob')
        @user.reload
        change_password(@user)
        assert controller.signed_in?
      end
      
      should 'be able to sign in with new password' do
        request_password_reset('bob@bob.bob')
        @user.reload
        change_password(@user)
        sign_out
        sign_in_as('bob@bob.bob', 'goodpassword')
        assert controller.signed_in?
      end
      
    end
    
  end
  
  
  private
  
  
  def request_password_reset(email)
    visit new_password_url
    fill_in "Email Address", :with => email
    click_button "reset password"
  end
  
  def change_password(user, options = {})
    options[:password]  ||= 'goodpassword'
    options[:confirm]   ||= options[:password]
    
    visit edit_user_password_path(:user_id => user,
                                  :token   => user.password_reset_token)
    fill_in "Choose password",    :with => options[:password]
    fill_in "Confirm password",   :with => options[:confirm]
    click_button "save this password"
  end
  
end
