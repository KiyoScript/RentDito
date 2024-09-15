class RenameMaintainerTableToMaintenanceStaff < ActiveRecord::Migration[7.1]
  def change
    rename_table :maintainers, :maintenance_staffs
  end
end
