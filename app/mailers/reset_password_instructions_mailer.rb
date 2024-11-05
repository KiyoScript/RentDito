class ResetPasswordInstructionsMailer < ApplicationMailer
  def send_email(user, token, opts={})
    @user = user
    @token = token
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Reset password instructions for #{@user.firstname}.")
  end
end
