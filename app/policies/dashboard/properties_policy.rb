class Dashboard::PropertiesPolicy < ApplicationPolicy
  def index?
    user.verified? && (user.landlord? || user.admin? || user.maintenance_staff? || user.utility_staff? || user.tenant? || user.agent? )
  end

  def new?
    user.landlord?
  end

  def create?
    user.landlord?
  end

  def edit?
    user.landlord?
  end

  def update?
    user.landlord?
  end

  def show?
    user.verified? && (user.landlord? || user.admin? || user.maintenance_staff? || user.utility_staff? || user.tenant?|| user.agent? )
  end

  def destroy?
    user.landlord?
  end
end
