class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.integer :city
      t.integer :barangay
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
