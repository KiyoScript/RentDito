class Dashboard::RoomsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?)
  end

  def new?
    user.landlord?
  end

  def create?
    user.landlord?
  end

  def show?
    user.landlord? || (user.admin? && user.verified?)
  end

  def destroy?
    user.landlord?
  end
end
