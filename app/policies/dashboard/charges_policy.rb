class Dashboard::ChargesPolicy < ApplicationPolicy
  def index?
    (user.tenant? && user.verified?)
  end

  def edit?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end

  def update?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end
end
