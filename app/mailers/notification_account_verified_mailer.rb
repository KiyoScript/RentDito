class NotificationAccountVerifiedMailer < ApplicationMailer
  def send_email(user)
    @user = user
    mail(from: "#{Rails.application.credentials.dig(:gmail, :name)} <#{Rails.application.credentials.dig(:gmail, :user_name)}>", to: email_to_deliver(user.email), subject: "Your account information is verified, #{@user.firstname}!")
  end
end
