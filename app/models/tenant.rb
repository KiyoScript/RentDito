class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_one :property_unit, through: :room
  has_one :property, through: :property_unit

  has_many :tickets, dependent: :destroy

  enum deck: { lower: 0, upper: 1 }

  after_create :decrement_room_deck_availability
  after_update :handle_room_transfer, if: -> { room_id.present? }

  def increment_room_deck_when_user_deactivate_account!
    if lower?
      room.increment!(:lower_deck)
    elsif upper?
      room.increment!(:upper_deck)
    end
  end


  def decrement_room_deck_when_user_not_deactivated!
    if lower?
      room.decrement!(:lower_deck)
    elsif upper?
      room.decrement!(:upper_deck)
    end
  end

  private

  def increment_room_deck_availability
    if lower?
      room.increment!(:lower_deck)
    elsif upper?
      room.increment!(:upper_deck)
    end
  end

  def handle_room_transfer
    decrement_room_deck_availability
  end


  def decrement_room_deck_availability
    if lower?
      room.decrement!(:lower_deck)
    elsif upper?
      room.decrement!(:upper_deck)
    end
  end
end
