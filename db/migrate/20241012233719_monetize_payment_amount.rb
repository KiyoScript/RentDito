class MonetizePaymentAmount < ActiveRecord::Migration[7.1]
  def change
    add_monetize :payments, :amount
  end
end
