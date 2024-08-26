class AddPropertyUnitRoomAndDeckToCaretakers < ActiveRecord::Migration[7.1]
  def change
    add_reference :caretakers, :property_unit, null: false, foreign_key: true
    add_reference :caretakers, :room, null: false, foreign_key: true
    add_column :caretakers, :deck, :integer
  end
end
