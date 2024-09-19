class MakeAssignedToIdNullableInTickets < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tickets, :assigned_to_id, true
  end
end
