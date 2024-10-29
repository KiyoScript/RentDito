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

  STATUS_BADGE_CLASS = {
    "done" => "badge bg-label-success",
    "under_review" => "badge bg-label-warning",
    "rejected" => "badge bg-label-danger"
  }.freeze


  def transaction_status_badge(status)
    badge_class = STATUS_BADGE_CLASS[status] || STATUS_BADGE_CLASS["done"]
    content_tag(:span, status.titleize, class: badge_class)
  end



end
