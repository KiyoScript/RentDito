class NotificationAssignedTicketMailer < ApplicationMailer
  def send_email(user, ticket)
    @user = user
    @ticket = ticket
    mail(from: "#{Rails.application.credentials.dig(:gmail, :name)} <#{Rails.application.credentials.dig(:gmail, :user_name)}>", to: email_to_deliver(user.email), subject: "Ticket ##{@ticket.id}!")
  end
end
