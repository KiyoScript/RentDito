class AllowNullForRoomInTenants < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tenants, :room_id, true
  end
end
