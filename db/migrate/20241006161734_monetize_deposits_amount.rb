class MonetizeDepositsAmount < ActiveRecord::Migration[7.1]
  def change
    add_monetize :deposits, :amount
  end
end
