class NotificationNewMonthlyBillMailer < ApplicationMailer
  def send_email(user, bill, charge)
    @user = user
    @bill = bill
    @charge = charge
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Your bill for #{@bill.due_date.strftime("%B %Y")} is here!")
  end
end
