class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :generated_password

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_one :maintenance_staff, dependent: :destroy
  has_one :utility_staff, dependent: :destroy
  has_one :tenant, dependent: :destroy
  has_one :balance, dependent: :destroy

  has_one_attached :avatar
  has_one_attached :signature
  has_one_attached :first_valid_id
  has_one_attached :second_valid_id

  # validates :avatar, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }
  validates :first_valid_id, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates :second_valid_id, content_type: ['image/png', 'image/jpg', 'image/jpeg']



  has_many :properties, dependent: :destroy
  has_many :assigned_tickets, as: :assigned_to, class_name: 'Ticket'
  has_many :billings, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  scope :admin, -> {where(role: 'admin')}
  scope :maintenance_staff, -> {where(role: 'maintenance_staff')}
  scope :utility_staff, -> {where(role: 'utility_staff')}
  scope :tenant, -> {where(role: 'tenant')}
  scope :agent, -> {where(role: 'agent')}


  scope :staff_members, ->{where(role: %i[admin maintenance_staff utility_staff])}

  enum status: { verified: 0, unverified: 1, rejected: 2, deactivated: 3, incomplete: 4 }
  enum gender: { male: 0, female: 1 }
  enum role: { landlord: 0, admin: 1, maintenance_staff: 2, utility_staff: 3, tenant: 4, agent: 5 }

  after_create :user_account_details
  after_create :generate_user_balance
  before_create :check_unique_full_name

  after_update :notify_users_status_with_email_notification!, if: -> { saved_change_to_status? }
  after_update :update_occupants_room_bedspace, if: -> { status == 'deactivated'}
  after_update :get_refund!, if: -> { status == 'deactivated'}

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
    "#{firstname} #{lastname}".titleize
  end


  def self.get_percentage(status_users, total_users)
    return "0.0%" if total_users.zero?

    total_percentage = (status_users.to_f / total_users.to_f) * 100
    return "(#{total_percentage.round(2)}%)"
  end

  def transfer_balance_to(recipient, amount)
    ActiveRecord::Base.transaction do
      # Update sender's balance
      self.balance.update!(amount: self.balance.amount - amount)

      # Update recipient's balance
      recipient.balance.update!(amount: recipient.balance.amount + amount)

      # Create a notification for the recipient
      Notification.create!(
        user: recipient,
        message: "#{self.fullname} transferred #{amount.format} to your balance.",
        notifiable: recipient
      )

      NotificationChannel.broadcast_to(recipient, { type: 'TransferBalance', message: "#{self.fullname} transferred #{amount.format} to your balance." })

      # Create transaction records for both sender and recipient
      Transaction.create!(
        user: self,
        amount: amount,
        status: 'done',
        transaction_type: 'transfer',
        transfer_from: "#{self.fullname}",
        transfer_to: "#{recipient.fullname}"
      )

      Transaction.create!(
        user: recipient,
        amount: amount,
        status: 'done',
        transaction_type: 'transfer',
        transfer_from: "#{self.fullname}",
        transfer_to: "#{recipient.fullname}"
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Transfer failed: #{e.message}")
    false
  end


  private


  def check_unique_full_name
    if User.exists?(firstname: firstname, lastname: lastname)
      errors.add(:base, "An account with this first name and last name already exists")
      throw :abort
    end
  end
  def user_account_details
    UserAccountDetailsMailer.send_email(self, generated_password).deliver_now if generated_password.present?
  end

  def notify_users_status_with_email_notification!
    case status
    when 'verified'
      NotificationAccountVerifiedMailer.send_email(self).deliver_now
    when 'rejected'
      NotificationAccountRejectedMailer.send_email(self).deliver_now
    end
  end

  def update_occupants_room_bedspace
    if tenant.present?
      tenant.increment_room_deck_when_user_deactivate_account!
    else
      utility_staff.increment_room_deck_when_user_deactivate_account!
    end
  end

  def generate_user_balance
    Balance.create(
      user: self,
      amount: 0.00
    )
  end

  def get_refund!
    Transaction.create!(
      user: self,
      amount: self.balance.amount,
      status: 'under_review',
      transaction_type: 'refund_request',
      reason: 'Checking out.'
    )
    self.balance.update!(amount: 0)
  end
end
