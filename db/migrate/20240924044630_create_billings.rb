class CreateBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :billings do |t|
      t.string :number
      t.integer :status, default: 0
      t.decimal :electricity_bill_partial_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :electricity_bill_total_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :water_bill_total_amount, precision: 6, scale: 2, default: 0.0
      t.decimal :charges_total_amount, precision: 6, scale: 2, default: 0.0
      t.date :electricity_bill_start_date
      t.date :electricity_bill_end_date
      t.date :water_bill_start_date
      t.date :water_bill_end_date
      t.date :wifi_and_rental_start_date, default: Date.today.beginning_of_month
      t.date :wifi_and_rental_end_date, default: Date.today.end_of_month
      t.datetime :due_date
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
