class Deposit < ApplicationRecord
  belongs_to :user

  has_one_attached :receipt

  has_many :transactions, dependent: :destroy

  enum status: [:pending, :done]
  monetize :amount_cents

  after_create :create_transaction


  def create_transaction
    Transaction.create!(
      user: user,
      transaction_type: 'deposit',
      amount_cents: amount_cents,
      charge_id: nil,
      deposit_id: id
    )
  end
end
