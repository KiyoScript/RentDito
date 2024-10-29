class AddPenaltyFieldsToCharge < ActiveRecord::Migration[7.1]
  def change
    add_column :charges, :extra_charge_electricity_penalty, :decimal, precision: 6, scale: 2
    add_column :charges, :water_sharing_penalty, :decimal, precision: 6, scale: 2
    add_column :charges, :wifi_and_monthly_rental_penalty, :decimal, precision: 6, scale: 2
    add_column :charges, :total_amount_penalty, :decimal, precision: 6, scale: 2
    add_column :charges, :has_penalty, :boolean, default: false
  end
end
