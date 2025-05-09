class Charge < ApplicationRecord
  attr_accessor :number_of_days

  belongs_to :user
  belongs_to :billing

  has_many :payments, dependent: :destroy

  enum status: [:unpaid, :paid, :pending]

  after_update_commit :update_charges_share_amount



  def self.ransackable_attributes(auth_object = nil)
    ["status"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "billing"]
  end


  private

  def update_charges_share_amount
    BillingChargeCalculation.new(self, number_of_days).update_charges_share_amount
  end
end
