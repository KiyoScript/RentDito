class AddAmountToPayFieldToCharges < ActiveRecord::Migration[7.1]
  def change
    add_column :charges, :amount_to_pay, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
