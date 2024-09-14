class AddAccommodationFieldToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :accomodation, :integer
  end
end
