class BillingChargeCalculation
  attr_reader :charge, :billing, :number_of_days

  def initialize(charge, number_of_days)
    @charge = charge
    @billing = charge.billing
    @number_of_days = number_of_days
  end

  def update_charges_share_amount
    case charge.billing.billing_type
    when 'electricity'
      charge.update_columns( electricity_share_amount: share_calculation(billing.electricity_bill_partial_amount) )
    when 'water'
      charge.update_columns( water_share_amount: share_calculation(billing.water_bill_total_amount))
    end

    update_billing_charges!
    update_charges_total_amount!(charge)
  end

  private

  def share_calculation(bill_total)
    bill_total ||= 0.00
    return 0.00 if total_days_of_all_occupants.zero?
    bill_total * (number_of_days.to_f / total_days_of_all_occupants)
  end

  def total_days_of_all_occupants
    @total_days_of_all_occupants ||= billing.total_days_of_all_occupants.to_f
  end

  def update_billing_charges!
    extra_charges = []

    if billing.billing_type == 'electricity'
      billing.charges.where.not(electricity_share_amount: 0.0).each do |charge|
        days_count_ratio = charge.days_count.to_f / total_days_of_all_occupants
        update_charge_share_amounts(charge, days_count_ratio)
        update_charges_total_amount!(charge)

        extra_charges << charge.extra_charge_amount
      end

      update_extra_charges_total_amount(extra_charges.sum)
    elsif billing.billing_type == 'water'
      billing.charges.where.not(water_share_amount: 0.0).each do |charge|
        days_count_ratio = charge.days_count.to_f / total_days_of_all_occupants
        update_charge_share_amounts(charge, days_count_ratio)
        update_charges_total_amount!(charge)
      end
    end
  end

  def update_charge_share_amounts(charge, days_count_ratio)
    case charge.billing.billing_type
      when 'electricity' then charge.update_columns( electricity_share_amount: billing.electricity_bill_total * days_count_ratio)
      when 'water' then charge.update_columns( water_share_amount: billing.water_bill_total_amount * days_count_ratio)
    end
  end

  def update_charges_total_amount!(charge)
    total_amount = [
      charge.extra_charge_amount || 0.0,
      charge.electricity_share_amount || 0.0,
      charge.water_share_amount || 0.0,
      charge.wifi_share_amount || 0.0,
      charge.monthly_rental_amount || 0.0
    ].sum

    charge.update_columns(total_amount: total_amount, amount_to_pay: total_amount)
    if charge.total_amount == 0.0
      charge.update_columns(status: 'paid')
    end
  end

  def update_extra_charges_total_amount(total_amount)
    @billing.update(charges_total_amount: total_amount)
  end
end
