class Dashboard::MaintenanceStaffsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?)
  end

  def new?
    user.landlord? || (user.admin? && user.verified?)
  end

  def create?
    user.landlord? || (user.admin? && user.verified?)
  end
end
