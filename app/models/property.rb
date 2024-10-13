class Property < ApplicationRecord
  belongs_to :user

  has_many :property_units, dependent: :destroy
  has_many :utility_staffs, dependent: :destroy, class_name: 'UtilityStaff'
  has_many :tenants, through: :property_units
  has_many :billings, dependent: :destroy
  has_many :rooms, through: :property_units

  validates :barangay, uniqueness: { scope: :city }
  validates :city, :barangay,  presence: true


  def address
    "#{city.titleize}, #{barangay.titleize}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ['city','barangay']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def occupants
    occupants = tenants + utility_staffs
    occupants.uniq
  end
end
