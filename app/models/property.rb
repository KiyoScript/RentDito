class Property < ApplicationRecord
  belongs_to :user

  has_many :property_units, dependent: :destroy
  has_many :caretaker, dependent: :destroy
  has_many :tenants, through: :property_units

  accepts_nested_attributes_for :property_units, allow_destroy: true


  validates :city, presence: true
  validates :barangay, presence: true

  enum city: { ormoc_city: 0, cebu_city: 1 }
  enum barangay: { don_felipe_larrazabal: 0, punta: 1, cogon: 2 }


  def display_name
    "#{city.titleize}, #{barangay.titleize}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ['city','barangay']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
