class Charge < ApplicationRecord
  attr_accessor :number_of_days

  belongs_to :user
  belongs_to :billing

  after_update_commit :update_charges_share_amount

  private

  def update_charges_share_amount
    BillingChargeCalculator.new(self, number_of_days).update_charges_share_amount
  end
end
