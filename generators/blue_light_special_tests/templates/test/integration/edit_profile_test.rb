require 'test_helper'

class EditProfileTest < ActionController::IntegrationTest
  
  context 'Editing a user profile' do
    
    setup do
      @user = Factory(:user, :password => 'password')
      sign_in_as(@user.email, 'password')
      visit edit_user_path(@user)
    end
    
    should_respond_with :success

    should "see the form with his info" do
      assert_select "input#user_first_name[value='#{@user.first_name}']"
      assert_select "input#user_last_name[value='#{@user.last_name}']"
      assert_select "input#user_email[value='#{@user.email}']"
    end

    should "update valid information and see the SHOW page" do
      fill_in "user_first_name", :with => 'OtherName'
      click_button 'Save'
      assert_contain /othername/i
    end

    should "update invalid information and see errors" do
      fill_in "user_first_name", :with => ''
      click_button 'Save'
      assert_contain /First name .* blank/i
    end
    
  end

end
