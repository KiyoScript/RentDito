class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_one :property_unit, through: :room
  has_one :property, through: :property_unit

  enum deck: { lower: 0, upper: 1 }

  after_create :update_room_deck_availability

  private

  def update_room_deck_availability
    if lower?
      room.decrement!(:lower_deck)
    elsif upper?
      room.decrement!(:upper_deck)
    end
  end
end
