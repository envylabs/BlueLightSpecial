##
# Delivers the UserMailer.deliver_mimi_welcome to the requested User by +id+
# as an asynchronous process.
# 
class DeliverWelcomeJob
  
  def initialize(user_id)
    @user_id = user_id
  end
  
  def perform
    if user = User.find_by_id(@user_id)
      BlueLightSpecialMailer.deliver_mimi_welcome(user)
    end
  end
  
end
