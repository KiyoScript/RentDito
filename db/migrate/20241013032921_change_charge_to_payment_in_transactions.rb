class ChangeChargeToPaymentInTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :transactions, :charge, foreign_key: true
    add_reference :transactions, :payment, null: true, foreign_key: true
  end
end
