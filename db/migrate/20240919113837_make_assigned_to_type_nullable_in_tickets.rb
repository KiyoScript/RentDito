class MakeAssignedToTypeNullableInTickets < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tickets, :assigned_to_type, true
  end
end
