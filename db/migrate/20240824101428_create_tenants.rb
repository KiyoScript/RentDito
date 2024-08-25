class CreateTenants < ActiveRecord::Migration[7.1]
  def change
    create_table :tenants do |t|
      t.datetime :check_in
      t.integer :deck
      t.integer :age
      t.date :date_of_birth
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.references :property_unit, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
