class Dashboard::PropertiesPolicy < ApplicationPolicy
  def index?
    user.verified? && (user.landlord? || user.admin? || user.maintenance_staff? || user.utility_staff? || user.tenant? )
  end

  def new?
    user.landlord?
  end

  def create?
    user.landlord?
  end

  def show?
    user.verified? && (user.landlord? || user.admin? || user.maintenance_staff? || user.utility_staff? || user.tenant? )
  end

  def destroy?
    user.landlord?
  end
end
