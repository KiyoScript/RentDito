class AddAdditionalFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :phone_number, :string
    add_column :users, :gender, :integer
    add_column :users, :role, :integer
    add_column :users, :status, :integer
    # Queries performance.
    add_index :users, :gender
    add_index :users, :role
    add_index :users, :status
  end
end
