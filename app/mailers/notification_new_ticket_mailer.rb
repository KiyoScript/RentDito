class NotificationNewTicketMailer < ApplicationMailer
  def send_email(user, ticket)
    @user = user
    @ticket = ticket
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Ticket ##{@ticket.id}!")
  end
end
