class CreateMaintainers < ActiveRecord::Migration[7.1]
  def change
    create_table :maintainers do |t|
      t.integer :city
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
