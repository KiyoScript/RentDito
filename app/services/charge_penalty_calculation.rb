class ChargePenaltyCalculation
  attr_reader :due_date, :charge

  def initialize(due_date, charge)
    @due_date = due_date
    @charge = charge
  end

  def total_with_penalty
    (charge  * penalty_rate).round(2)
  end

  private

  def penalty_rate
    overdue_days = (Date.current - due_date.to_date).to_i
    return 0 if overdue_days <= 0
    (overdue_days.to_f / 5).ceil * 0.05
  end
end
