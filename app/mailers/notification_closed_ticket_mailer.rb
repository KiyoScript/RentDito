class NotificationClosedTicketMailer < ApplicationMailer
  def send_email(user, ticket)
    @user = user
    @ticket = ticket
    mail(from: email_sender, to: email_to_deliver(user.email), subject: "Your ticket ##{@ticket.id} is closed today!")
  end
end
