class BlueLightSpecialMailer < MadMimiMailer

  def mimi_change_password(user)
    from       BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject    I18n.t(:change_password,
                      :scope   => [:blue_light_special, :models, :blue_light_special_mailer],
                      :default => "Change your password")
    body       :user => user
  end
  
  def mimi_welcome(user)
    from       BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject    I18n.t(:welcome,
                      :scope   => [:blue_light_special, :models, :blue_light_special_mailer],
                      :default => "Welcome")
    body       :user => user
  end

end
