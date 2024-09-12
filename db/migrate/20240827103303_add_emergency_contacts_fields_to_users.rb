class AddEmergencyContactsFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_contact_name, :string
    add_column :users, :first_contact_number, :string
    add_column :users, :first_relationship, :string
    add_column :users, :second_contact_name, :string
    add_column :users, :second_contact_number, :string
    add_column :users, :second_relationship, :string
    add_column :users, :third_contact_number, :string
    add_column :users, :fourth_contact_number, :string
  end
end
