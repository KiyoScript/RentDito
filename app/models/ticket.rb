class Ticket < ApplicationRecord
  belongs_to :tenant
  belongs_to :assigned_to, polymorphic: true, optional: true

  enum :category, [:internet_connection, :maintenance_request, :check_out, :others]
  enum :status, [:open, :pending, :closed]
  enum :label, [:urgent, :normal, :minor]

  scope :assigned_to_user, ->(user) { where(assigned_to: user) }

  validate :check_out_datetime_valid, if: -> { category == 'check_out' }

  has_many_attached :images

  def self.ransackable_attributes(auth_object = nil)
    ['category', 'status', 'label', 'title']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


  private
  def check_out_datetime_valid
    min_days = 15
    if datetime.present? && datetime < DateTime.now + min_days.days
      errors.add(:datetime, "must be at least #{min_days} days in the future for check out.")
    end
  end
end
