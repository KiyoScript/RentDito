class MonetizeBilling < ActiveRecord::Migration[7.1]
  def change
    add_monetize :billings, :electricity_bill_partial_amount
    add_monetize :billings, :electricity_bill_total_amount
    add_monetize :billings, :water_bill_total_amount
    add_monetize :billings, :charges_total_amount
  end
end
