class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :generated_password

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_one :maintenance_staff, dependent: :destroy
  has_one :utility_staff, dependent: :destroy
  has_one :tenant, dependent: :destroy

  has_one_attached :avatar
  has_one_attached :signature
  has_one_attached :first_valid_id
  has_one_attached :second_valid_id
  has_one :balance

  # validates :avatar, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }

  has_many :properties, dependent: :destroy
  has_many :assigned_tickets, as: :assigned_to, class_name: 'Ticket'
  has_many :billings
  has_many :charges
  has_many :deposits
  has_many :transactions
  has_many :payments

  scope :admin, -> {where(role: 'admin')}
  scope :maintenance_staff, -> {where(role: 'maintenance_staff')}
  scope :utility_staff, -> {where(role: 'utility_staff')}
  scope :tenant, -> {where(role: 'tenant')}

  scope :staff_members, ->{where(role: %i[admin maintenance_staff utility_staff])}

  enum status: { verified: 0, unverified: 1, rejected: 2, deactivated: 3, incomplete: 4 }
  enum gender: { male: 0, female: 1 }
  enum role: { landlord: 0, admin: 1, maintenance_staff: 2, utility_staff: 3, tenant: 4 }

  after_create :user_account_details
  after_create :generate_user_balance

  accepts_nested_attributes_for :maintenance_staff, allow_destroy: true
  accepts_nested_attributes_for :utility_staff, allow_destroy: true
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

  def generate_user_balance
    Balance.create(
      user: self,
      amount: 0.00
    )
  end
end
