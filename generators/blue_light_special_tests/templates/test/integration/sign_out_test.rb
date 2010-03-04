require 'test_helper'

class SignOutTest < ActionController::IntegrationTest
  
  context 'Signing out as a user' do
    
    stubbing_any_authorize_net_customer_profile_request do
      
      should 'see "Signed out"' do
        sign_up(:email => 'bob@bob.bob')
        sign_out
        assert_match(/Signed out/, response.body)
      end
    
      should 'be signed out' do
        sign_up(:email => 'bob@bob.bob')
        sign_out
        assert !controller.signed_in?
      end
    
      should 'be signed out when I return' do
        sign_up(:email => 'bob@bob.bob')
        sign_out
        visit root_url
        assert !controller.signed_in?
      end
    
    end
    
  end
  
end
