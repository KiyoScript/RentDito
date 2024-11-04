class UserAccountDetailsMailer < ApplicationMailer
  def send_email(user, password)
    @user = user
    @password = password
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Complete Your Registration, #{@user.firstname}!")
  end
end
