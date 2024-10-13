class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :charge


has_many :transactions, dependent: :destroy

  enum status: [:pending, :done]

  monetize :amount_cents

  validate :sufficient_balance

  after_create :create_transaction!
  after_create :update_user_charge
  after_create :update_charges_status


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
    charge_amount_to_pay = Money.new(charge.amount_to_pay * 100, 'PHP')
    paid_amount = Money.new(charge.paid_amount * 100, 'PHP')

    updated_amount_to_pay = charge_amount_to_pay - amount
    updated_paid_amount = paid_amount + amount

    charge.update_columns(paid_amount: updated_paid_amount, amount_to_pay: updated_amount_to_pay)
  end

  def update_charges_status
    charge.update_columns(status: charge.amount_to_pay == 0.0? 'paid' : 'pending' )
  end


  private

  def sufficient_balance
    charge_money = Money.new(charge.amount_to_pay * 100, "PHP")
    if user.balance.amount < charge_money
      errors.add(:base, "User balance is insufficient to pay for this charge.")
    end
  end
end
