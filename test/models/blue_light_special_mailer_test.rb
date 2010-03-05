require 'test_helper'

class BlueLightSpecialMailerTest < ActiveSupport::TestCase

  context "A change password email" do
    setup do
      @user  = Factory(:user)
      @user.forgot_password!
      BlueLightSpecialMailer.deliver_mimi_change_password @user
      @email = ActionMailer::Base.deliveries.last
    end

    should "be from DO_NOT_REPLY" do
      assert_equal BlueLightSpecial.configuration.mailer_sender, @email.from
    end

    should "be sent to user" do
      assert_match /#{@user.email}/i, @email.recipients
    end

    should "contain a link to edit the user's password" do
      host = ActionMailer::Base.default_url_options[:host]
      regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.password_reset_token}}
      assert_match regexp, @email.body[:url]
    end
    
    should "set its subject" do
      assert_match /Change your password/, @email.subject
    end
  end
  
  context "A welcome email" do
    setup do
      @user  = Factory(:user)
      Delayed::Job.work_off
      @email = ActionMailer::Base.deliveries.last
    end

    should "be from DO_NOT_REPLY" do
      assert_equal BlueLightSpecial.configuration.mailer_sender, @email.from
    end

    should "be sent to user" do
      assert_match /#{@user.email}/i, @email.recipients
    end

    should "set its subject" do
      assert_match /welcome/i, @email.subject
    end
  end

end
