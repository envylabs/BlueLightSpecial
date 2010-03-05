require 'test_helper'
require 'facebooker/mock/service'
require 'facebooker/mock/session'

class FacebookTest < ActionController::IntegrationTest
  
  context 'Signing in with Facebook' do
    
    setup do
      Facebooker::MockService.fixture_path = File.dirname(__FILE__) + '/../facebooker_fixtures'
      fb_session = Facebooker::MockSession.create
      fb_session.secure!
      BlueLightSpecial::PasswordsController.any_instance.stubs(:facebook_session).returns(fb_session)
    end
    
    should 'find an existing user with the facebook uid' do
      user = Factory( :facebook_user,
                      :facebook_uid => 8055,
                      :email => 'bob@facebook.com')

      visit new_password_url
      assert controller.signed_in?
      assert_equal controller.current_user, user
    end
    
    should 'create a new user when the facebook uid is not found' do
      assert_nil User.find_by_facebook_uid(8055)
    
      visit new_password_url
      assert controller.signed_in?
      assert_equal 8055, controller.current_user.facebook_uid
    end
  
    should 'copy the facebook user details' do
      visit new_password_url
      assert controller.signed_in?
      assert_equal 'bob@facebook.com', controller.current_user.email
    end
  
  end

end
