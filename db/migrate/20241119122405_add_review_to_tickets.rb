class AddReviewToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :rating, :integer
    add_column :tickets, :review, :text
  end
end
