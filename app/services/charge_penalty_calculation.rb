class ChargePenaltyCalculation
  attr_reader :due_date, :charge

  def initialize(due_date, charge)
    @due_date = due_date
    @charge = charge
  end

  def total_with_penalty
    (charge * penalty_rate).round(2)
  end

  private

  def penalty_rate
    overdue_days = (Date.current - due_date.to_date).to_i
    return 0 if overdue_days <= 0  # No penalty if due date is not passed

    case overdue_days
    when 1..5
      0.05  # 5% penalty for 1-5 days overdue
    when 6..Float::INFINITY
      # Start at 5% and increase by 10% for each additional overdue day
      0.05 + (overdue_days - 5) * 0.10
    end
  end
end
