module ApplicationHelper
  include Pagy::Frontend

  STATUS_BADGE_CLASS = {
    "verified" => "badge bg-label-success",
    "unverified" => "badge bg-label-warning",
    "rejected" => "badge bg-label-danger",
    "deactivated" => "badge bg-label-danger"
  }.freeze


  GENDER_BADGE_CLASS = {
    "female" => "badge bg-label-primary",
    "male" => "badge bg-label-info"
  }.freeze


  def status_badge(status)
    badge_class = STATUS_BADGE_CLASS[status] || STATUS_BADGE_CLASS["verified"]
    content_tag(:span, status.capitalize, class: badge_class)
  end

  def gender_badge(gender)
    badge_class = GENDER_BADGE_CLASS[gender] || GENDER_BADGE_CLASS["female"]
    content_tag(:span, gender.capitalize, class: badge_class)
  end

  def fullname(user)
    user.firstname + " " + user.lastname
  end
end
