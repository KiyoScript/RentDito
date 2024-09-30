class MonetizeChargesAmount < ActiveRecord::Migration[7.1]
  def change
    add_monetize :charges, :extra_charge_amount
    add_monetize :charges, :electricity_share_amount
    add_monetize :charges, :water_share_amount
    add_monetize :charges, :wifi_share_amount
    add_monetize :charges, :monthly_rental_amount
    add_monetize :charges, :total_amount
  end
end
