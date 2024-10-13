class RemoveStatusFromBillings < ActiveRecord::Migration[7.1]
  def change
    remove_column :billings, :status, :integer
  end
end
