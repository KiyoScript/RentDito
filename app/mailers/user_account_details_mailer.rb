class UserAccountDetailsMailer < ApplicationMailer
  def send_email(user, password)
    @user = user
    @password = password
    mail(to: email_to_deliver('johnlloyddesape@gmail.com'), subject: "RentDito - Your account details!!!")
  end
end
