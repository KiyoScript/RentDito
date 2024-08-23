class CreateCaretakers < ActiveRecord::Migration[7.1]
  def change
    create_table :caretakers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
