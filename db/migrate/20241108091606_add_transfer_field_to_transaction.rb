class AddTransferFieldToTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :transfer_from, :string
    add_column :transactions, :transfer_to, :string
  end
end
