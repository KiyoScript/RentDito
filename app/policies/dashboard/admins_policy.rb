class Dashboard::AdminsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?)
  end

  def create?
    user.landlord?
  end
end
