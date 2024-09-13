class Dashboard::AdminsPolicy < ApplicationPolicy
  def index?
    user.landlord? || user.admin?
  end

  def create?
    user.landlord?
  end

  def destroy?
    user.landlord?
  end
end
