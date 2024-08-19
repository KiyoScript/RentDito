class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :generated_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum status: { verified: 0, unverified: 1, rejected: 2, deactivated: 3 }
  enum gender: { male: 0, female: 1 }
  enum role: { landlord: 0, admin: 1, caretaker: 2, tenant: 3 }

  after_create :user_account_details


  def self.ransackable_attributes(auth_object = nil)
    ['email','firstname', 'gender', 'lastname', 'phone_number', 'role', 'status']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
  def user_account_details
    UserAccountDetailsMailer.send_email(self, generated_password).deliver_now if generated_password.present?
  end
end
