class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  private
  def email_to_deliver(email)
    if Rails.env == "production"
      email
    else
      ENV['MAIL_INTERCEPTOR_EMAIL']
    end
  end

  def email_sender
    "#{Rails.application.credentials.dig(:gmail, :name)} <#{Rails.application.credentials.dig(:gmail, :user_name)}>"
  end
end
