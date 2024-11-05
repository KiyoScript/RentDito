class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :suggestion
      t.decimal :amount, precision: 6, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :charge, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
