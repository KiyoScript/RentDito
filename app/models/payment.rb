class Payment < ApplicationRecord
  include Dashboard::BillingsHelper

  belongs_to :user
  belongs_to :charge


  has_many :transactions, dependent: :destroy

  enum status: [:pending, :done]

  monetize :amount_cents

  validate :sufficient_balance

  after_create :create_transaction!
  after_create :update_user_charge


  def create_transaction!
    Transaction.create!(
      user: user,
      transaction_type: 'payment',
      amount: amount,
      payment_id: id,
      deposit_id: nil,
      status: 'done'
    )

    user.balance.update(amount: user.balance.amount - amount)
  end


  def update_user_charge
    paid_amount = Money.new(charge.paid_amount * 100, 'PHP')

    updated_paid_amount = paid_amount + amount

    charge.update_columns(
      paid_amount: updated_paid_amount,
      status: 'paid',
      extra_charge_electricity_penalty: (charge.billing.billing_type == "electricity") ? charge_penalty(charge, 'electricity') : nil,
      water_sharing_penalty: (charge.billing.billing_type == "water") ? charge_penalty(charge, 'water') : nil,
      wifi_and_monthly_rental_penalty: (charge.billing.billing_type == "wifi") ? charge_penalty(charge, 'wifi') : nil,
      total_amount_penalty: any_penalty?(charge) ? amount : 0.00,
      has_penalty: any_penalty?(charge) ? true : false
    )

  end

  def self.ransackable_attributes(auth_object = nil)
    ["suggestion"]
  end

  private

  def sufficient_balance
    if user.balance.amount < amount
      errors.add(:base, "User balance is insufficient to pay for this charge.")
    end
  end
end
