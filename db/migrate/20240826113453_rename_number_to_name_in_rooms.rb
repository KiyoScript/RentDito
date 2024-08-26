class RenameNumberToNameInRooms < ActiveRecord::Migration[7.1]
  def change
    rename_column :rooms, :number, :name
    change_column :rooms, :name, :string
  end
end
