require 'test_helper'

class SignInTest < ActionController::IntegrationTest
  
  context 'Signing in as a User' do
    
    context 'who is not in the system' do
      
      should 'see a failure message' do
        sign_in_as('someone@somewhere.com', 'password')
        assert_match(/Bad email or password/, response.body)
      end
      
      should 'not be signed in' do
        sign_in_as "someone@somewhere.com", 'password'
        assert !controller.signed_in?
      end
      
    end
    
    context 'when confirmed' do
      
      setup do
        @user = Factory(:user, :email => "bob@bob.bob", :password => "password")
      end
      
      should 'be signed in' do
        sign_in_as 'bob@bob.bob', 'password'
        assert controller.signed_in?
      end
      
      should 'see "Signed In"' do
        sign_in_as 'bob@bob.bob', 'password'
        assert_match %r{Signed in}, @response.body
      end
      
      should 'be signed in on subsequent requests' do
        sign_in_as 'bob@bob.bob', 'password'
        reset_session
        visit root_url
        assert controller.signed_in?
      end
      
    end
        
    context 'when confirmed but with bad credentials' do
      
      setup do
        @user = Factory(:user, :email => 'bob@bob.bob', :password => 'password')
      end
      
      should 'not be signed in' do
        sign_in_as 'bob@bob.bob', 'badpassword'
        assert !controller.signed_in?
      end
      
      should 'see "Bad email or password"' do
        sign_in_as 'bob@bob.bob', 'badpassword'
        assert_match /Bad email or password/, response.body
      end
      
    end
    
  end
  
end
