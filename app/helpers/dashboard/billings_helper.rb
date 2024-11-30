module Dashboard::BillingsHelper
  def billing_type_icon(billing)
    case billing.downcase
    when 'water'
      "<i class='bx bxs-droplet' style='color: blue;'></i>".html_safe
    when 'electricity'
      "<i class='bx bxs-bolt' style='color: yellow;'></i>".html_safe
    when 'wifi'
      "<i class='bx bx-wifi' style='color: green;'></i>".html_safe
    when 'rental'
      "<i class='bx bx-home' style='color: orange;'></i>".html_safe
    else
      "<i class='bx bx-question-mark' style='color: gray;'></i>".html_safe
    end
  end



  def total_amount_penalty(charge)
    return charge.total_amount if charge.paid?

    case charge.billing.billing_type
    when 'electricity'
      return [charge_penalty(charge, 'electricity'), charge.total_amount].sum
    when 'water'
      return [charge_penalty(charge, 'water'), charge.total_amount].sum
    when 'wifi'
      return [charge_penalty(charge, 'wifi'), charge.total_amount].sum
    end
  end


  def charge_penalty(charge, charge_type)
    wifi_rental_total_amount = [charge.extra_charge_amount, charge.monthly_rental_amount, charge.wifi_share_amount].sum
    extra_charge_with_electricity = [charge.extra_charge_amount + charge.electricity_share_amount].sum
    case charge_type
    when 'electricity'
      ChargePenaltyCalculation.new(charge.billing.electricity_bill_end_date, extra_charge_with_electricity).total_with_penalty
    when 'water'
      ChargePenaltyCalculation.new(charge.billing.water_bill_end_date, charge.water_share_amount).total_with_penalty
    when 'wifi'
      ChargePenaltyCalculation.new(charge.billing.wifi_and_rental_end_date, wifi_rental_total_amount).total_with_penalty
    end
  end

  def any_penalty?(charge)
    case charge.billing.billing_type
    when 'electricity'
      %w[extra_charge_amount electricity_share_amount].any? do |charge_type|
        has_penalty?(charge, charge_type)
      end
    when 'water'
      %w[water_share_amount].any? do |charge_type|
        has_penalty?(charge, charge_type)
      end
    when 'wifi'
      %w[wifi_share_amount monthly_rental_amount].any? do |charge_type|
        has_penalty?(charge, charge_type)
      end
    end
  end

  def has_penalty?(charge, charge_type)
    case charge_type
    when 'extra_charge_amount'
      (charge.unpaid? || charge.pending?) && charge.billing.electricity_bill_end_date < Date.today
    when 'electricity_share_amount'
      (charge.unpaid? || charge.pending?) && charge.billing.electricity_bill_end_date < Date.today
    when 'water_share_amount'
      (charge.unpaid? || charge.pending?) && charge.billing.water_bill_end_date < Date.today
    when 'wifi_share_amount'
      (charge.unpaid? || charge.pending?) && charge.billing.wifi_and_rental_end_date < Date.today
    when 'monthly_rental_amount'
      (charge.unpaid? || charge.pending?) && charge.billing.wifi_and_rental_end_date < Date.today
    end
  end

  def unique_billing_months(limit = 5)
    Billing.select("DATE_TRUNC('month', due_date) as billing_month")
           .group("billing_month")
           .order("billing_month DESC")
           .limit(limit)
           .map { |billing| billing.billing_month }
  end

  def bill_month_year_options(model)
    model
      .select(Arel.sql("DATE_TRUNC('month', due_date) AS month_year"))
      .order(Arel.sql("month_year DESC"))
      .map do |billing|
        date = billing.month_year
        [date.strftime("%B %Y"), date.strftime("%Y-%m")]
      end
  end

  def charge_duedate(charge)
    case charge.billing.billing_type
    when 'electricity'
      charge.billing.electricity_bill_end_date.strftime("%B %d, %Y")
    when 'water'
      charge.billing.water_bill_end_date.strftime("%B %d, %Y")
    when 'wifi'
      charge.billing.wifi_and_rental_end_date.strftime("%B %d, %Y")
    end
  end
end
