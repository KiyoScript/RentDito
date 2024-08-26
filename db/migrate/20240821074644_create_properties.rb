class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :city
      t.string :barangay
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
