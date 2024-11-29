class ChargePresenter
  def initialize(charge)
    @charge = charge
  end

  def got_penalty?
    case @charge.billing.billing_type
    when 'electricity'
      (@charge.unpaid? || @charge.pending?) && @charge.billing.electricity_bill_end_date < Date.today
    when 'water'
      (@charge.unpaid? || @charge.pending?) && @charge.billing.water_bill_end_date < Date.today
    when 'wifi'
      (@charge.unpaid? || @charge.pending?) && @charge.billing.wifi_and_rental_end_date < Date.today
    end
  end

  def total_with_penalty(due_date, billing_type)
    base_amount = case billing_type
                  when 'water' then @charge.water_share_amount
                  when 'electricity' then @charge.electricity_share_amount + @charge.extra_charge_amount
                  when 'wifi' then @charge.wifi_share_amount
                  when 'rental' then @charge.monthly_rental_amount
                  end

    (base_amount * penalty_rate(due_date)).round(2)
  end

  def number_of_day(due_date)
    overdue_days = (Date.current - due_date.to_date).to_i
    return "no days overdue" if overdue_days <= 0
    "#{overdue_days} day#{'s' if overdue_days > 1}"
  end

  def penalty_rate(due_date)
    overdue_days = (Date.current - due_date.to_date).to_i
    return 0 if overdue_days <= 0  # No penalty if due date is not passed

    case overdue_days
    when 1
      0.05  # 5% penalty for 1 days overdue
    when 2..6
      0.15  # 15% penalty for 2 to 6 days overdue
    when 7..Float::INFINITY
      # Start at 15% and increase by 10% for each additional overdue every 5 days
      0.15 + ((overdue_days - 2) / 5) * 0.10
    end
  end

  def day_rate(due_date)
    overdue_days = (Date.current - due_date.to_date).to_i
    return "0 days" if overdue_days <= 0

    case overdue_days
    when 1 then "1 day"
    when 2..6 then "2 to 6 days"
    else "7 or more days"
    end
  end

end
