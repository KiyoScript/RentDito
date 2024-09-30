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
end
