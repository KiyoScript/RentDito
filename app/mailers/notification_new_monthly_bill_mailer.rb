class NotificationNewMonthlyBillMailer < ApplicationMailer
  def send_email(user, bill, charge)
    @user = user
    @bill = bill
    @charge = charge

    # Determine the bill type based on the charge amounts
    bill_type = if @charge.water_share_amount != 0
                  "Water"
                elsif @charge.electricity_share_amount != 0
                  "Electricity"
                else
                  "Wi-Fi & rental"
                end

    subject_line = "#{bill_type} bill for #{@bill.due_date.strftime("%B %Y")} is here!"

    mail(
      from: email_sender,
      to: email_to_deliver(user.email),
      subject: subject_line
    )
  end
end
