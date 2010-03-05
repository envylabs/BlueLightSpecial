##
# Delivers the BlueLightSpecial.deliver_mimi_change_password to the requested 
# User by +id+ as an asynchronous process.
# 
class DeliverChangePasswordJob
  
  def initialize(user_id)
    @user_id = user_id
  end
  
  def perform
    if user = User.find_by_id(@user_id)
      BlueLightSpecialMailer.deliver_mimi_change_password(user)
    end
  end
  
end
