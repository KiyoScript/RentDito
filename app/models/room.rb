class Room < ApplicationRecord
  belongs_to :property_unit
  belongs_to :property

  validates :number, presence: true


  scope :with_bedspace_availability, ->(availability) do
    case availability
    when 'lower_deck'
      where.not(lower_deck: 0)
    when 'upper_deck'
      where.not(upper_deck: 0)
    when 'both'
      where.not(lower_deck: 0).where.not(upper_deck: 0)
    else
      all
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["lower_deck", "number", "property_id", "property_unit_id", "upper_deck"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["property", "property_unit"]
  end
end
