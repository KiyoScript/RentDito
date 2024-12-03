module ApplicationHelper
  include Pagy::Frontend

  STATUS_BUTTON_CLASS = {
    "verified" => "btn btn-success btn-sm dropdown-toggle hide-arrow",
    "unverified" => "btn btn-warning btn-sm dropdown-toggle hide-arrow",
    "rejected" => "btn btn-danger btn-sm dropdown-toggle hide-arrow",
    "deactivated" => "btn btn-danger btn-sm dropdown-toggle hide-arrow",
    "incomplete" => "btn btn-dark btn-sm dropdown-toggle hide-arrow"
  }.freeze

  STATUS_LABEL_BUTTON_CLASS = {
    "verified" => "btn btn-label-success btn-sm hide-arrow",
    "unverified" => "btn btn-label-warning btn-sm hide-arrow",
    "rejected" => "btn btn-label-danger btn-sm hide-arrow",
    "deactivated" => "btn btn-label-danger btn-sm hide-arrow",
    "incomplete" => "btn btn-label-dark btn-sm hide-arrow"
  }.freeze

  STATUS_BADGE_CLASS = {
    "verified" => "badge bg-label-success",
    "unverified" => "badge bg-label-warning",
    "rejected" => "badge bg-label-danger",
    "deactivated" => "badge bg-label-danger",
    "incomplete" => "badge bg-label-dark",
    "open" => "badge bg-label-primary",
    "pending" => "badge bg-label-info",
    "closed" => "badge bg-label-secondary"
  }.freeze

  CHARGE_STATUS_BADGE_CLASS = {
    "unpaid" => "badge bg-label-danger",
    "pending" => "badge bg-label-warning",
    "paid" => "badge bg-label-success"
  }.freeze


  GENDER_BADGE_CLASS = {
    "female" => "badge bg-label-primary",
    "male" => "badge bg-label-info"
  }.freeze


  DECK_BADGE_CLASS = {
    1 || 2 => "badge bg-label-success",
    0 => "badge bg-label-danger"
  }.freeze

  def status_badge(status)
    badge_class = STATUS_BADGE_CLASS[status] || STATUS_BADGE_CLASS["verified"]
    content_tag(:span, status.titleize, class: badge_class)
  end

  def charge_status_badge(status)
    badge_class = CHARGE_STATUS_BADGE_CLASS[status] || CHARGE_STATUS_BADGE_CLASS["unpaid"]
    content_tag(:span, status.titleize, class: badge_class)
  end

  def gender_badge(gender)
    badge_class = GENDER_BADGE_CLASS[gender] || GENDER_BADGE_CLASS["female"]
    content_tag(:span, gender.capitalize, class: badge_class)
  end

  def deck_badge(deck)
    deck_class = DECK_BADGE_CLASS[deck] || DECK_BADGE_CLASS[1]
    deck_class = "badge bg-label-success" if deck_class.nil?
    content_tag(:span, deck, class: deck_class)
  end

  def status_button_class(status)
    STATUS_BUTTON_CLASS[status] || STATUS_BUTTON_CLASS["unverified"]
  end

  def status_label_button_class(status)
    STATUS_LABEL_BUTTON_CLASS[status] || STATUS_LABEL_BUTTON_CLASS["unverified"]
  end

  def property_unit_badges(property)
    property.property_units.map do |unit|
      content_tag(:span, unit.name, class: 'badge bg-label-primary')
    end.join(' ').html_safe
  end

  def avatar(user)
    if user.avatar.attached?
      rails_blob_url(user.avatar.blob)
    else
      user.male? ? asset_path('male_avatar.png') : asset_path('female_avatar.png')
    end
  end

  def first_valid_id(user)
    if user.first_valid_id.attached?
      rails_blob_url(user.first_valid_id.blob)
    else
      asset_path('id.png')
    end
  end

  def second_valid_id(user)
    if user.second_valid_id.attached?
      rails_blob_url(user.second_valid_id.blob)
    else
      asset_path('id.png')
    end
  end


  def users_avatars(users)
    content_tag(:ul, class: "list-unstyled avatar-group d-flex flex-row align-items-center justify-content-start") do
      users.first(4).map do |user|
        default_avatar = user.male? ? 'male_avatar.png' : 'female_avatar.png'
        avatar_url = user.avatar.attached? ? rails_blob_url(user.avatar) : asset_path(default_avatar)

        content_tag(:li, class: "avatar pull-up",
                    data: { bs_toggle: "tooltip", popup: "tooltip-custom", bs_placement: "top", bs_title: user.fullname }) do
          image_tag(avatar_url, alt: "#{user.firstname}'s Avatar", class: "rounded-circle")
        end
      end.join.html_safe +

      if users.size > 4
        additional_count = users.size - 4
        content_tag(:li, class: "avatar") do
          content_tag(:span,
            class: "avatar-initial rounded-circle pull-up",
            data: { bs_toggle: "tooltip", bs_placement: "bottom", bs_title: "+#{additional_count} more" }
          ) do
            "+#{additional_count}"
          end
        end
      elsif users.size == 0
        content_tag(:li, class: "avatar pull-up") do

        end
      else
        ""
      end
    end
  end

  def peso(amount)
    number_to_currency(amount, unit: "₱", precision: 2)
  end

  def notification_icon_and_color(notifiable_type, message = nil)
    if message&.include?('penalty')
      { icon: "bx bx-calendar-exclamation", color: "bg-label-danger" }
    else
      case notifiable_type
      when "Ticket"
        if message.include?("closed")
          { icon: "bx bx-check-circle", color: "bg-label-success" }
        elsif message.include?("created")
          { icon: "bx bxs-file-plus", color: "bg-label-primary" }
        else
          { icon: "bx bx-wrench", color: "bg-label-info" }
        end
      when "Billing"
        if message.include?('generated')
          { icon: "bx bx-money", color: "bg-label-info" }
        else
          { icon: "bx bx-info-circle", color: "bg-label-warning" }
        end
      else
        { icon: "bx bx-question-mark", color: "bg-label-secondary" }
      end
    end
  end

  def get_penalty_rate(due_date, charge)
    overdue_days = (Date.current - due_date.to_date).to_i
    return 0 if overdue_days <= 0

    case overdue_days
    when 1
      0.05
    when 2..6
      0.15
    when 7..Float::INFINITY
      0.15 + ((overdue_days - 2) / 5) * 0.10
    end
  end

end
