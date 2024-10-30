class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type
      t.decimal :amount, precision: 6, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :charge, null: true, foreign_key: true
      t.references :deposit, null: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
