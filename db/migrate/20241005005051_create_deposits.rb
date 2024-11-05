class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.decimal :amount, precision: 6, scale: 2
      t.string :reference_number
      t.integer :status, default: 0
      t.datetime :date_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
