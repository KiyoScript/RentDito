class RenameCaretakerTableToUtilityStaff < ActiveRecord::Migration[7.1]
  def change
    rename_table :caretakers, :utility_staff
  end
end
