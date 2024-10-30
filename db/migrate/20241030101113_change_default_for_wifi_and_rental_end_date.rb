class ChangeDefaultForWifiAndRentalEndDate < ActiveRecord::Migration[7.1]
  def change
    change_column_default :billings,  :wifi_and_rental_end_date, from: Date.today.end_of_month, to: Date.today.next_month.beginning_of_month
  end
end
