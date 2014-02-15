class UserMailer < ActionMailer::Base
  default from: "support@incomehawk.com"

  # send welcome email to customer on their registration
  def welcome_email(user)
    @user = user
    @url  = 'http://incomehawkapp-com.herokuapp.comlogin'
    mail(to: @user.email, subject: 'Welcome to My Site')
  end
end
