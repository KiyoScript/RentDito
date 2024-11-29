class NotificationPenaltyMailer < ApplicationMailer
  def send_email(user, billing, charge)
    @user = user
    @billing = billing
    @charge = charge
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Penalty Zone this #{Date.current.strftime("%B %d, %Y")}")
  end
end
