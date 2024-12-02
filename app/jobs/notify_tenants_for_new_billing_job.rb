class NotifyTenantsForNewBillingJob < ApplicationJob

  def perform(billing_id)
    billing = Billing.find(billing_id)
    billing.property.tenants.each do |tenant|
      Notification.create!(
        user: tenant.user,
        message: "#{billing.due_date.strftime("%B %Y")} #{billing.billing_type == "wifi" ? ' Wi-Fi & rental' : billing.billing_type } billing report is generated.",
        notifiable: billing
      )

      NotificationChannel.broadcast_to(tenant.user, {
        type: 'NewBilling',
        message: "#{billing.due_date.strftime("%B %Y")} #{billing.billing_type == "wifi" ? ' Wi-Fi & rental' : billing.billing_type } billing report is generated."
      })

      NotificationNewMonthlyBillMailer
        .send_email(tenant.user, billing, tenant.user.charges.find_by(billing_id: billing))
        .deliver_now
    end
  end
end
