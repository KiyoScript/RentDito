class MoveAgeFieldToUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :tenants, :age
    add_column :users, :age, :integer
  end
end
