class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :generated_password

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_one :maintainer, dependent: :destroy
  has_one :caretaker, dependent: :destroy
  has_one :tenant, dependent: :destroy

  has_many :properties, dependent: :destroy

  scope :admin, -> {where(role: 'admin')}
  scope :maintainer, -> {where(role: 'maintainer')}
  scope :caretaker, -> {where(role: 'caretaker')}
  scope :tenant, -> {where(role: 'tenant')}

  enum status: { verified: 0, unverified: 1, rejected: 2, deactivated: 3, incomplete: 4 }
  enum gender: { male: 0, female: 1 }
  enum role: { landlord: 0, admin: 1, maintainer: 2, caretaker: 3, tenant: 4 }

  after_create :user_account_details

  accepts_nested_attributes_for :maintainer, allow_destroy: true
  accepts_nested_attributes_for :caretaker, allow_destroy: true
  accepts_nested_attributes_for :tenant, allow_destroy: true

  def self.ransackable_attributes(auth_object = nil)
    ['email','firstname', 'gender', 'lastname', 'phone_number', 'role', 'status']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def fullname
    "#{firstname} #{lastname}"
  end

  private

  def user_account_details
    UserAccountDetailsMailer.send_email(self, generated_password).deliver_now if generated_password.present?
  end
end
