class AddTransferDateToTenant < ActiveRecord::Migration[7.1]
  def change
    add_column :tenants, :transfer_date, :datetime
  end
end
