class AddBillingTypeToBilling < ActiveRecord::Migration[7.1]
  def change
    add_column :billings, :billing_type, :string
  end
end
