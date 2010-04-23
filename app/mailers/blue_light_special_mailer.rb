class BlueLightSpecialMailer < MadMimiMailer

  def mimi_change_password(user)
    @url = edit_user_password_url(user,
                                  :token  => user.password_reset_token,
                                  :escape => false)
    
    mail :to => user.email,
         :from => BlueLightSpecial.configuration.mailer_sender,
         :subject => I18n.t(:change_password,
                            :scope   => [:blue_light_special, :models, :blue_light_special_mailer],
                            :default => "Change your password")
  end
  
  def mimi_welcome(user)
    mail :to => user.email,
         :from => BlueLightSpecial.configuration.mailer_sender,
         :subject => I18n.t(:welcome,
                            :scope   => [:blue_light_special, :models, :blue_light_special_mailer],
                            :default => "Welcome")
  end

end
