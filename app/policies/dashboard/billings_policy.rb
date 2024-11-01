class Dashboard::BillingsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end

  def new?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end

  def create?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end

  def destroy?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end

  def show?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end
end
