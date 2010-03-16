require File.dirname(__FILE__) + "/../../test_helper"

class Admin::UsersTest < ActionController::IntegrationTest

  setup do
    ActionMailer::Base.deliveries.clear
  end

  teardown do
    ActionMailer::Base.deliveries.clear
  end

  context 'Signed in as an admin' do

    setup do
      @bob = Factory(:user, :email => 'bob@bob.bob', :first_name => 'Bob')
      @joe = Factory(:user, :email => 'joe@joe.joe', :first_name => 'Joe')
      @ted = Factory(:user, :email => 'ted@ted.ted', :first_name => 'Ted')
      @admin_user = Factory(:admin_user, :email => 'admin@example.com')
      sign_in_as(@admin_user.email, @admin_user.password)
    end

    context 'when listing users' do
        
      should 'show the list of users' do
        visit admin_users_url
        assert_contain(/bob@bob.bob/)
        assert_contain(/joe@joe.joe/)
        assert_contain(/ted@ted.ted/)
      end
    
    end
    
    context 'when creating a new user' do
      
      context 'with valid data' do
                  
        should 'display "Created [name]"' do
          create_user(:first_name => 'Tom', :last_name => 'Tom')
          assert_contain(/Created Tom Tom/)
        end

        should 'redirect to the user show page' do
          create_user(:email => 'tom@tom.tom')
          user = User.find_by_email('tom@tom.tom')
          assert_equal current_url, admin_user_url(user)
        end

        should 'be able to set the role' do
          create_user(:email => 'tom@tom.tom', :role => 'admin')
          user = User.find_by_email('tom@tom.tom')
          assert user.admin?
        end

      end
      
      context 'with invalid data' do
        
        should 'display error messages' do
          create_user(
            :first_name => '',
            :last_name => '',
            :email => 'invalidemail',
            :password_confirmation => 'bad')
          assert_contain(/First name can't be blank/)
          assert_contain(/Last name can't be blank/)
          assert_contain(/Email is invalid/)
          assert_contain(/Password doesn't match confirmation/)
        end
        
        should 'redisplay the new user form' do
          create_user(:first_name => '')
          assert_have_selector 'form.new_user'
        end
        
      end
      
    end
  
    context 'when editing a user' do

      context 'with valid data' do
      
        should 'display "Updated [name]"' do
          edit_user(@ted, :first_name => 'Tom', :last_name => 'Tom' )
          assert_contain(/Updated Tom Tom/)
        end
      
        should 'redirect to the user show page' do
          edit_user(@ted, :email => 'tom@tom.tom')
          user = User.find_by_email('tom@tom.tom')
          assert_equal current_url, admin_user_url(user)
        end
        
        should 'be able to change the role' do
          edit_user(@ted, :role => 'admin')
          @ted.reload
          assert @ted.admin?
        end
        
      end
      
      context 'with invalid data' do
        
        should 'display error messages' do
          edit_user(@ted,
            :first_name => '',
            :last_name => '',
            :email => 'invalidemail',
            :password => 'good',
            :password_confirmation => 'bad')
          assert_contain(/First name can't be blank/)
          assert_contain(/Last name can't be blank/)
          assert_contain(/Email is invalid/)
          assert_contain(/Password doesn't match confirmation/)
        end
        
        should 'redisplay the edit form' do
          edit_user(@ted, :first_name => '')
          assert_have_selector 'form.edit_user'
        end
        
      end
      
    end
    
    context 'when deleting a user' do

      should 'display "Deleted [name]"' do
        delete_user(@bob)
        assert_contain(/Deleted Bob/)
      end

      should 'redirect to the user list' do
        delete_user(@bob)
        assert_equal current_url, admin_users_url
      end
      
      should 'not display the deleted user in the list' do
        delete_user(@bob)
        assert_not_contain(/bob@bob.bob/)
      end
      
      should 'not allow deleting currently logged in user' do
        visit admin_user_url(@admin_user), :delete
        assert_contain(/Cannot delete yourself/)
        assert_contain(/admin@example.com/)
      end

    end
               
  end
  
  context 'Signed in as a non-admin user' do

    setup do
      @user = Factory(:user)
      sign_in_as(@user.email, @user.password)
    end
    
    should 'not give access' do
      visit admin_users_url
      assert_not_equal current_url, admin_users_url
    end
    
  end
  
  
  private
  
  
  def create_user(options = {})
    visit admin_users_url
    click_link 'New User'
    fill_in 'Email',            :with => options[:email]                  || 'tom@tom.tom'
    fill_in 'Password',         :with => options[:password]               || 'password'
    fill_in 'Confirm Password', :with => options[:password_confirmation]  || options[:password] || 'password'
    fill_in 'First Name',       :with => options[:first_name]             || 'Tom'
    fill_in 'Last Name',        :with => options[:last_name]              || 'Tom'
    select options[:role] || '', :from => 'Role'
    click_button 'Save'
  end
  
  def edit_user(user, options = {})
    visit admin_user_url(user)
    click_link 'Edit'
    fill_in 'Email',            :with => options[:email]                  || 'tom@tom.tom'
    fill_in 'Password',         :with => options[:password]               || ''
    fill_in 'Confirm Password', :with => options[:password_confirmation]  || options[:password] || ''
    fill_in 'First Name',       :with => options[:first_name]             || 'Tom'
    fill_in 'Last Name',        :with => options[:last_name]              || 'Tom'
    select options[:role] || '', :from => 'Role'
    click_button 'Save'
  end
  
  def delete_user(user)
    visit admin_user_url(user)
    click_link 'Delete'
  end
    
end
