class NotificationAccountVerifiedMailer < ApplicationMailer
  def send_email(user)
    @user = user
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Your account information is verified, #{@user.firstname}!")
  end
end
