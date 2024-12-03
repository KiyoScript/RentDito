class ChangeForeignKeyOnTenantAndUtilityStaff < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :tenants, :rooms
    add_foreign_key :tenants, :rooms, on_delete: :nullify
  end
end
