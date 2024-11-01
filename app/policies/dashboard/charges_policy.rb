class Dashboard::ChargesPolicy < ApplicationPolicy
  def index?
    (user.tenant? && user.verified?)
  end

  def edit?
    (user.tenant? && user.verified?)
  end

  def update?
    (user.tenant? && user.verified?)
  end
end
