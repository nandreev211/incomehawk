class UserMailer < ActionMailer::Base
  default from: "support@incomehawkapp.com"

  # send welcome email to customer on their registration
  def welcome_email(user)
    @user = user
    @url  = 'http://incomehawkapp.com/login'
    mail(to: @user.email, subject: 'Welcome to My Site')
  end
end
