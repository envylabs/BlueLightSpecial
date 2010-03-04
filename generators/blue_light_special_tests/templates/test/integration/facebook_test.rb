require File.dirname(__FILE__) + "/../test_helper"
require 'facebooker/mock/service'
require 'facebooker/mock/session'

class FacebookTest < ActionController::IntegrationTest

  context 'Signing in with Facebook' do
    
    setup do
      Facebooker::MockService.fixture_path = File.dirname(__FILE__) + '/../facebooker_fixtures'
      fb_session = Facebooker::MockSession.create
      fb_session.secure!
      CitiesController.any_instance.stubs(:facebook_session).returns(fb_session)
    end
    
    should 'find an existing user with the facebook uid' do
      user = Factory( :facebook_user,
                      :facebook_uid => 8055,
                      :email => 'bob@facebook.com',
                      :first_name => 'Bob',
                      :last_name => 'Jones',
                      :display_name => 'Bob Jones',
                      :zip_code => '11111')

      visit city_url(City.default)
      assert controller.signed_in?
      assert_equal controller.current_user, user
    end
    
    stubbing_any_authorize_net_customer_profile_request(:success => true, :id => '54321') do

      should 'create a new user when the facebook uid is not found' do
        assert_nil User.find_by_facebook_uid(8055)
      
        visit city_url(City.default)
        assert controller.signed_in?
        assert_equal controller.current_user.facebook_uid, 8055
      end
    
      should 'copy the facebook user details' do
        visit city_url(City.default)
        assert controller.signed_in?
        assert_equal controller.current_user.first_name, 'Dave'
        assert_equal controller.current_user.last_name, 'Fetterman'
        assert_equal controller.current_user.display_name, 'Dave Fetterman'
        assert_equal controller.current_user.email, 'bob@facebook.com'
      end

    end
  
  end

end
