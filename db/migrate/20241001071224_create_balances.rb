class CreateBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :balances do |t|
      t.decimal :amount, precision: 6, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
