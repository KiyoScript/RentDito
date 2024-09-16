class Dashboard::MaintenanceStaffsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?)
  end

  def new?
    user.landlord?
  end

  def create?
    user.landlord?
  end
end
