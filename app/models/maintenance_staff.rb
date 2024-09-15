class MaintenanceStaff < ApplicationRecord
  belongs_to :user

  enum city: { ormoc_city: 0, cebu_city: 1 }

  validates :city, presence: true

end
