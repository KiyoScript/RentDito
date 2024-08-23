module ApplicationHelper
  include Pagy::Frontend

  STATUS_BADGE_CLASS = {
    "verified" => "badge bg-label-success",
    "unverified" => "badge bg-label-warning",
    "rejected" => "badge bg-label-danger",
    "deactivated" => "badge bg-label-danger",
    "incomplete" => "badge bg-label-warning"
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
    content_tag(:span, status.capitalize, class: badge_class)
  end

  def gender_badge(gender)
    badge_class = GENDER_BADGE_CLASS[gender] || GENDER_BADGE_CLASS["female"]
    content_tag(:span, gender.capitalize, class: badge_class)
  end

  def deck_badge(deck)
    deck_class = DECK_BADGE_CLASS[deck] || DECK_BADGE_CLASS[1]
    content_tag(:span, deck, class: deck_class)
  end
end
