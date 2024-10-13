module Dashboard::TransactionsHelper
  def formmated_date(date)
    case date.to_date
    when Date.today
      "Today"
    when Date.yesterday
      "Yesterday"
    when 1.week.ago.to_date..Date.today
      "Last Week"
    when 1.month.ago.to_date..Date.today
      "Last Month"
    else
      date.strftime("%B %d, %Y")
    end
  end
end
