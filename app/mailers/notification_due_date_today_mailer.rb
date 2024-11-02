class NotificationDueDateTodayMailer < ApplicationMailer
  def send_email(user, billing, charge)
    @user = user
    @billing = billing
    @charge = charge
    mail(to: email_to_deliver(user.email), subject: "Wifi and Monthly Rental Due Date is is today")
  end
end
