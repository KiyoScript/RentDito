class NotificationAssignedTicketMailer < ApplicationMailer
  def send_email(user, ticket)
    @user = user
    @ticket = ticket
    mail(to: email_to_deliver(user.email), subject: "Ticket ##{@ticket.id}!")
  end
end
