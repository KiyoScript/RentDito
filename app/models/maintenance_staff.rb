class MaintenanceStaff < ApplicationRecord
  belongs_to :user

  enum city: { ormoc_city: 0, cebu_city: 1, ormoc_and_cebu: 2 }

  validates :city, presence: true

end
