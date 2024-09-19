module ApplicationHelper
  include Pagy::Frontend

  STATUS_BUTTON_CLASS = {
    "verified" => "btn btn-success btn-sm dropdown-toggle hide-arrow",
    "unverified" => "btn btn-warning btn-sm dropdown-toggle hide-arrow",
    "rejected" => "btn btn-danger btn-sm dropdown-toggle hide-arrow",
    "deactivated" => "btn btn-danger btn-sm dropdown-toggle hide-arrow",
    "incomplete" => "btn btn-warning btn-sm dropdown-toggle hide-arrow"
  }.freeze

  STATUS_BADGE_CLASS = {
    "verified" => "badge bg-label-success",
    "unverified" => "badge bg-label-warning",
    "rejected" => "badge bg-label-danger",
    "deactivated" => "badge bg-label-danger",
    "incomplete" => "badge bg-label-warning",
    "open" => "badge bg-label-primary",
    "pending" => "badge bg-label-info",
    "closed" => "badge bg-label-secondary"
  }.freeze

  LABEL_BADGE_CLASS = {
    "normal" => "badge bg-label-info",
    "urgent" => "badge bg-label-danger",
    "minor" => "badge bg-label-warning"
  }

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

  def label_badge(label)
    badge_class = LABEL_BADGE_CLASS[label] || LABEL_BADGE_CLASS["normal"]
    content_tag(:span, label.titleize, class: badge_class)
  end


  def gender_badge(gender)
    badge_class = GENDER_BADGE_CLASS[gender] || GENDER_BADGE_CLASS["female"]
    content_tag(:span, gender.capitalize, class: badge_class)
  end

  def deck_badge(deck)
    deck_class = DECK_BADGE_CLASS[deck] || DECK_BADGE_CLASS[1]
    content_tag(:span, deck, class: deck_class)
  end

  def status_button_class(status)
    STATUS_BUTTON_CLASS[status] || STATUS_BUTTON_CLASS["unverified"]
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
      users.map do |user|

        default_avatar = user.male? ? 'male_avatar.png' : 'female_avatar.png'

        avatar_url = user.avatar.attached? ? rails_blob_url(user.avatar) : asset_path(default_avatar)
        content_tag(:li, class: "avatar pull-up",
                    data: { bs_toggle: "tooltip", popup: "tooltip-custom", bs_placement: "top", bs_title: user.fullname }) do
          image_tag(avatar_url, alt: "#{user.firstname}'s Avatar", class: "rounded-circle")
        end
      end.join.html_safe

    end
  end
end
