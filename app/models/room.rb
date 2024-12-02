class Room < ApplicationRecord
  belongs_to :property_unit
  belongs_to :property

  has_many :tenants
  has_many :utility_staffs

  before_destroy :check_associations

  validates :name, :upper_deck, :lower_deck, presence: true
  validates :name, uniqueness: { scope: :property_unit_id, message: "must be unique within the same property unit" }

  enum :accomodation, [:boarding_house, :apartment, :dormitory, :studio, :condo ]

  scope :with_bedspace_availability, ->(availability) do
    case availability
    when 'lower_deck'
      where.not(lower_deck: 0)
    when 'upper_deck'
      where.not(upper_deck: 0)
    else
      all
    end
  end

  scope :total_upper_deck, -> { sum(:upper_deck) }
  scope :total_lower_deck, -> { sum(:lower_deck) }

  scope :property_unit_name_eq, ->(name) do
    joins(:property_unit).where(property_units: { name: name })
  end


  def self.ransackable_attributes(auth_object = nil)
    ["lower_deck", "name", "property_id", "property_unit_id", "upper_deck", "accomodation"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["property", "property_unit"]
  end


  private

  def check_associations
    if tenants.any? || utility_staffs.any?
      errors.add(:base, "Cannot delete a room with active occupants.")
      throw(:abort)
    end
  end
end
