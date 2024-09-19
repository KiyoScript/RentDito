class AddTypeToTenants < ActiveRecord::Migration[7.1]
  def change
    add_column :tenants, :type, :string
  end
end
