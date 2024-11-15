class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true
  belongs_to :deposit, optional: true

  enum transaction_type: [:deposit, :payment, :transfer, :refund_request]
  enum status: [:under_review, :done, :rejected]

  monetize :amount_cents

  after_update :update_transaction_and_deposit_status

  def self.ransackable_attributes(auth_object = nil)
    ["transaction_type", "status", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end


  def update_transaction_and_deposit_status
    return unless saved_change_to_status?

    case status
    when 'done'
      if deposit.present?
        deposit.update(status: :done)
        user.balance.update(amount: user.balance.amount + deposit.amount)
      end
    when 'rejected'
      if deposit.present?
        deposit.update(status: :rejected)
      end
    end
  end
end
