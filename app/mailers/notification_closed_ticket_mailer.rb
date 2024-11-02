class NotificationClosedTicketMailer < ApplicationMailer
  def send_email(user, ticket)
    @user = user
    @ticket = ticket
    mail(to: email_to_deliver(user.email), subject: "Your ticket ##{@ticket.id} is closed today!")
  end
end
