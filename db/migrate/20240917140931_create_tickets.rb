class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.integer :category
      t.integer :status
      t.string :title
      t.text :description
      t.integer :label
      t.datetime :datetime
      t.references :tenant, null: false, foreign_key: true
      t.references :assigned_to, polymorphic: true, null: false

      t.timestamps
    end
  end
end
