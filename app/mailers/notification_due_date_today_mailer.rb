class NotificationDueDateTodayMailer < ApplicationMailer
  def send_email(user, billing, charge, subject)
    @user = user
    @billing = billing
    @charge = charge
    @subject = subject
    mail(from: email_sender, to: email_to_deliver(user.email), subject: subject)
  end
end
