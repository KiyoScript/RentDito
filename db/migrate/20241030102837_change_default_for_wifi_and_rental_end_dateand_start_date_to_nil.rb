class ChangeDefaultForWifiAndRentalEndDateandStartDateToNil < ActiveRecord::Migration[7.1]
  def change
    change_column_default :billings, :wifi_and_rental_end_date, from: Date.today.next_month.beginning_of_month, to: nil
    change_column_default :billings, :wifi_and_rental_start_date, from: Date.today.beginning_of_month, to: nil
  end
end
