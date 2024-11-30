class ChargePenaltyNotificationJob < ApplicationJob
  include Dashboard::BillingsHelper


  def perform
    today = Date.current
    Parallel.each(Billing.all.includes(:property), in_threads: 4) do |billing|
      billing.property.occupants.each do |tenant|

        subject = "Penalty Zone for #{billing.billing_type == 'wifi' ? 'Wi-Fi and Rental' : billing.billing_type.titleize } Bill this #{today.strftime("%B %d, %Y")}"
        charge = tenant.user.charges.find_by(billing_id: billing.id)

        case billing.billing_type
        when 'water'
          if has_penalty?(charge, 'water_share_amount')
            NotificationPenaltyMailer.send_email(tenant.user, billing, charge).deliver_now
            Notification.create!(
              user: tenant.user,
              message: subject,
              notifiable: billing
            )
            NotificationChannel.broadcast_to(tenant.user, { type: "Charge Penalty", message: subject })
          end
        when 'electricity'
          if has_penalty?(charge, 'electricity_share_amount')
            NotificationPenaltyMailer.send_email(tenant.user, billing, charge).deliver_now
            Notification.create!(
              user: tenant.user,
              message: subject,
              notifiable: billing
            )
            NotificationChannel.broadcast_to(tenant.user, { type: "Charge Penalty", message: subject })
          end
        when 'wifi'
          if has_penalty?(charge, 'wifi_share_amount')
            NotificationPenaltyMailer.send_email(tenant.user, billing, charge).deliver_now
            Notification.create!(
              user: tenant.user,
              message: subject,
              notifiable: billing
            )
            NotificationChannel.broadcast_to(tenant.user, { type: "Charge Penalty", message: subject })
          end
        end
      end
    end
  end
end
