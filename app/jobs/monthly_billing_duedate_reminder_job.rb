class MonthlyBillingDuedateReminderJob < ApplicationJob

  def perform
    today = Date.today
    Parallel.each(Billing.all.includes(:property), in_threads: 4) do |billing|
      billing.property.occupants.each do |tenant|
        subject = nil
        case billing.billing_type
        when 'water'
          if (today == billing.water_bill_end_date)
            subject = "Water bill due date is today."
          end
        when 'electricity'
          if (today == billing.electricity_bill_end_date)
            subject = "Electricity bill due date is today."
          end
        when 'wifi'
          if (today == billing.wifi_and_rental_end_date)
            subject = "Wi-Fi and rental due date is today."
          end
        end
        charge = tenant.user.charges.find_by(billing_id: billing.id)
        if (subject && charge && ((!charge.water_share_amount.zero? || !charge.electricity_share_amount.zero?) || !charge.wifi_share_amount.zero? || !charge.monthly_rental_amount.zero?))
          NotificationDueDateTodayMailer.send_email(tenant.user, billing, charge, subject).deliver_now
          Notification.create!(
            user: tenant.user,
            message: subject,
            notifiable: billing
          )
          NotificationChannel.broadcast_to(tenant.user, { type: "DueDateBilling", message: subject })
        end
      end
    end
  end
end
