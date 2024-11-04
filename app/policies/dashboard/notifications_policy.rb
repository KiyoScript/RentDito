class Dashboard::NotificationsPolicy < ApplicationPolicy
  def index?
    user.landlord? || user.verified?
  end
end
