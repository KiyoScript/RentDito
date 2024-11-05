class MonetizeBalanceAmount < ActiveRecord::Migration[7.1]
  def change
    add_monetize :balances, :amount
  end
end
