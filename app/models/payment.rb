class Payment < ApplicationRecord
  belongs_to :billing
  belongs_to :user

  enum :status, [:Unpaid, :Paid, :Pending]

  monetize :amount_cents
end
