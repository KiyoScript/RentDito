class Dashboard::FeedbacksPolicy < ApplicationPolicy
  def index?
    user.verified? && (user.landlord? || user.admin?)
  end
end
