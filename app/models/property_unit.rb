class PropertyUnit < ApplicationRecord
  belongs_to :property
  has_many :rooms, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
