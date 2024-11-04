class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true


  scope :unread, -> { where(read: false) }

  def self.ransackable_attributes(auth_object = nil)
    ["message",  "read"]
  end
end
