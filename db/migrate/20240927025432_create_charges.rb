class CreateCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :charges do |t|
      t.decimal :extra_charge_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :electricity_share_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :water_share_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :wifi_share_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :monthly_rental_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :total_amount, precision: 6, scale: 2, default: 0.0
      t.integer :days_count
      t.references :user, null: false, foreign_key: true
      t.references :billing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
