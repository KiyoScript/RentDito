class CreatePropertyUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :property_units do |t|
      t.string :name
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
