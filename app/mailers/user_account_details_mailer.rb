class UserAccountDetailsMailer < ApplicationMailer
  def send_email(user, password)
    @user = user
    @password = password
    mail(to: email_to_deliver('danielligutan123@gmail.com'), subject: "Welcome to RentDito, #{@user.firstname}!")
  end
end
