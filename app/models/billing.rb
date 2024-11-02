class Billing < ApplicationRecord
  belongs_to :user
  belongs_to :property


  has_many :charges, dependent: :destroy

  before_create :generate_billing_number
  after_create :generate_charges
  after_create :notify_all_tenants!

  monetize :electricity_bill_partial_amount_cents
  monetize :electricity_bill_total_amount_cents
  monetize :charges_total_amount_cents
  monetize :water_bill_total_amount_cents

  def electricity_bill_date_covered
    "#{electricity_bill_start_date.strftime("%B %d, %Y")} - #{electricity_bill_end_date.strftime("%B %d, %Y")}"
  end

  def water_bill_date_covered
    "#{water_bill_start_date.strftime("%B %d, %Y")} - #{water_bill_end_date.strftime("%B %d, %Y")}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["property_id", "number"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "property"]
  end

  def total_amount
    e_total_amount  = electricity_bill_total_amount? ? electricity_bill_total_amount : electricity_bill_partial_amount
    e_total_amount += water_bill_total_amount
    return e_total_amount
  end

  def date_covered
    start_date = [electricity_bill_start_date, water_bill_start_date].compact.min
    end_date = [electricity_bill_end_date, water_bill_end_date].compact.max

    return "#{start_date.strftime("%B %d, %Y")} - #{end_date.strftime("%B %d, %Y")}"
  end

  def month
    start_date = [electricity_bill_start_date, water_bill_start_date].compact.min
    return "#{start_date.strftime("%B %Y")}"
  end

  def electricity_bill_total
    total = electricity_bill_total_amount? ? electricity_bill_total_amount : electricity_bill_partial_amount
    return total
  end

  def wifi_and_rental_date_covered
    "#{wifi_and_rental_start_date.strftime("%B %d, %Y")} - #{wifi_and_rental_end_date.strftime("%B %d, %Y")}"
  end

  def total_days_of_all_occupants
    charges.sum(:days_count)
  end

  def wifi_bill_total_amount
    charges.sum(:wifi_share_amount)
  end

  def monthly_rental_total_amount
    charges.sum(:monthly_rental_amount)
  end

  def total_charges_amount
    charges.sum(:total_amount)
  end

  def total_paid_amount
    charges.paid.sum(:total_amount)
  end

  def total_water_billing_amount
    charges.sum(:water_share_amount)
  end

  def total_water_billing_paid_amount
    charges.paid.sum(:water_share_amount)
  end

  def total_electricity_billing_amount
    [charges.sum(:electricity_share_amount), charges.sum(:extra_charge_amount)].sum
  end

  def total_electricity_billing_paid_amount
    [charges.paid.sum(:electricity_share_amount), charges.paid.sum(:extra_charge_amount)].sum
  end

  def total_wifi_billing_amount
    charges.sum(:wifi_share_amount)
  end

  def total_wifi_billing_paid_amount
    charges.paid.sum(:wifi_share_amount)
  end

  def total_monthly_rental_billing_amount
    charges.sum(:monthly_rental_amount)
  end

  def total_monthly_rental_billing_paid_amount
    charges.paid.sum(:monthly_rental_amount)
  end

  private

  def generate_billing_number
    self.number = "#BILL-#{SecureRandom.hex(5).upcase}" if number.blank?
  end

  def generate_charges
    total_user_days = property.tenants.count + property.utility_staffs.count * 30
    number_of_days = 0.00
    user_wifi_share = 60.00
    user_monthly_rental = 1500.00
    extra_charge_amount = 0.00
    electricity_total_amount = electricity_bill_total_amount? ? electricity_bill_total_amount : electricity_bill_partial_amount


    property.occupants.each do |tenant|
      water_share = (water_bill_total_amount * number_of_days) / total_user_days
      electricity_share = (electricity_total_amount * number_of_days) / total_user_days

      Charge.create!(
        user: tenant.user,
        billing: self,
        extra_charge_amount: extra_charge_amount.round(2),
        electricity_share_amount: electricity_share.round(2),
        water_share_amount: water_share.round(2),
        monthly_rental_amount: user_monthly_rental,
        days_count: number_of_days,
        wifi_share_amount: user_wifi_share,
        status: tenant.user.utility_staff? ? 'paid' : 'unpaid',
        total_amount: (extra_charge_amount.to_f + water_share.to_f + electricity_share.to_f + user_monthly_rental.to_f + user_wifi_share.to_f ).round(2),
        amount_to_pay: (extra_charge_amount.to_f + water_share.to_f + electricity_share.to_f + user_monthly_rental.to_f + user_wifi_share.to_f ).round(2)
      )
    end
  end

  def notify_all_tenants!
    property.occupants.each do |tenant|
      Notification.create!(
        user: tenant.user,
        message: "#{self.due_date.strftime("%B %Y")} billing report is generated.",
        notifiable: self
      )
      NotificationChannel.broadcast_to(tenant.user, { type: 'NewBilling', message: "#{self.due_date.strftime("%B %Y")} billing report is generated." })
      NotificationNewMonthlyBillMailer.send_email(tenant.user, self, tenant.user.charges.find_by(billing_id: self))
    end
  end
end
