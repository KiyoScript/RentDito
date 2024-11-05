class AddReasonFieldToTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :reason, :text
  end
end
