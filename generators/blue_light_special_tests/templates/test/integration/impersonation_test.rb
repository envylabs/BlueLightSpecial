require 'test_helper'

class ImpersonationTest < ActionController::IntegrationTest
  
  context 'When impersonating another user' do
    
    setup do
      @bob = Factory(:user, :email => 'bob@bob.bob', :display_name => 'Bobby')
      @admin_user = Factory(:admin_user, :email => 'admin@twongo.com')
      sign_in_as @admin_user.email, @admin_user.password
      impersonate(@bob)
    end
    
    should 'be signed in' do
      assert controller.signed_in?
    end        
    
    should 'be logged in as bob' do
      assert_equal controller.current_user, @bob
    end
    
    should 'be able to go back to the original admin user' do
      delete impersonate_url
      assert controller.signed_in?
      assert_equal controller.current_user, @admin_user
    end
    
  end
  
  
  private
  
  
  def impersonate(user)
    post impersonate_url(user)
  end
  
end
