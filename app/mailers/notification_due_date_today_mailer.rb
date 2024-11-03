class NotificationDueDateTodayMailer < ApplicationMailer
  def send_email(user, billing, charge, subject)
    @user = user
    @billing = billing
    @charge = charge
    @subject = subject
    mail(to: email_to_deliver(user.email), subject: subject)
  end
end
