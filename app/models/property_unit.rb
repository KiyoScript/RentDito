class PropertyUnit < ApplicationRecord
  belongs_to :property

  has_many :rooms, dependent: :destroy
  has_many :tenants, through: :rooms
  has_many :utility_staffs, through: :rooms
  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def occupants
    tenants + utility_staffs
  end
end
