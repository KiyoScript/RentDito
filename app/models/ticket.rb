class Ticket < ApplicationRecord
  belongs_to :tenant
  belongs_to :assigned_to, polymorphic: true, optional: true

  enum :category, [:internet_connection, :maintenance_request, :check_out, :others]
  enum :status, [:open, :pending, :closed]
  enum :label, [:urgent, :normal, :minor]

  scope :assigned_to_user, ->(user) { where(assigned_to: user) }

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many_attached :images

  validate :check_out_datetime_valid, if: -> { category == 'check_out' }


  after_create :notify_landlord!
  after_update :notify_assignment!, if: -> { saved_change_to_assigned_to_id? }
  after_update :notify_closed_ticket!, if: -> { status == 'closed' }





  def self.ransackable_attributes(auth_object = nil)
    ['category', 'status', 'label', 'title']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.get_percentage(ticket_status, total_tickets)
    return "0.0%" if total_tickets.zero?

    total_percentage = (ticket_status.to_f / total_tickets.to_f) * 100
    return "(#{total_percentage.round(2)}%)"
  end


  private

  def notify_landlord!
    User.landlord.each do|landlord|
      Notification.create!(
        user: landlord,
        message: "New ticket has been created by #{tenant.user.fullname} with ID##{id}.",
        notifiable: self
      )

      NotificationChannel.broadcast_to(landlord, { type: 'TicketCreated', message: "New ticket has been created by #{tenant.user.fullname} with ID##{id}." })
      NotificationNewTicketMailer.send_email(landlord, self).deliver_now
    end
  end

  def notify_assignment!
    Notification.create!(
      user: assigned_to,
      message: "You have been assigned ticket with ID##{id}.",
      notifiable: self
    )
    NotificationChannel.broadcast_to(assigned_to, { type: 'Ticket', message: "You have been assigned ticket with ID##{id}." })
    NotificationAssignedTicketMailer.send_email(assigned_to, self).deliver_now

    Notification.create!(
      user: tenant.user,
      message: "Your ticket ##{id} was assigned to #{assigned_to.fullname}.",
      notifiable: self
    )
    NotificationChannel.broadcast_to(tenant.user, { type: 'Ticket', message: "Your ticket ##{id} was assigned to #{assigned_to.fullname}." })
  end


  def notify_closed_ticket!
    Notification.create!(
      user: tenant.user,
      message: "Your ticket ##{id} is already closed.",
      notifiable: self
    )
    NotificationChannel.broadcast_to(tenant.user, { type: 'TicketClosed', message: "Your ticket ##{id} is already closed." })
    NotificationClosedTicketMailer.send_email(tenant.user, self).deliver_now
  end

  def check_out_datetime_valid
    min_days = 15
    if datetime.present? && datetime < DateTime.now + min_days.days
      errors.add(:datetime, "must be at least #{min_days} days in the future for check out.")
    end
  end
end
