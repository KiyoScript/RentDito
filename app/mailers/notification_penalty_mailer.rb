class NotificationPenaltyMailer < ApplicationMailer
  def send_email(user, billing, charge)
    @user = user
    @billing = billing
    @charge = charge
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Penalty Zone for #{@billing.billing_type == 'wifi' ? 'Wi-Fi and Rental' : @billing.billing_type.titleize } Bill this #{Date.current.strftime("%B %d, %Y")}")
  end
end
