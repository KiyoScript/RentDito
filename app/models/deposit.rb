class Deposit < ApplicationRecord
  belongs_to :user

  has_one_attached :receipt

  has_many :transactions, dependent: :destroy

  enum status: [:pending, :done, :rejected]
  monetize :amount_cents

  validates :reference_number, uniqueness: true

  after_create :create_transaction


  def create_transaction
    Transaction.create!(
      user: user,
      transaction_type: 'deposit',
      amount_cents: amount_cents,
      payment_id: nil,
      deposit_id: id
    )
  end
end
