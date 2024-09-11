class MovedDateOfBirthFieldToUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :tenants, :date_of_birth
    add_column :users, :date_of_birth, :date
  end
end
