class OnboardingPolicy < ApplicationPolicy
  def show?
    user.landlord? || user.unverified? || user.incomplete? || user.deactivated? || user.rejected?
  end

  def update?
    user.landlord? || user.unverified? || user.incomplete? || user.deactivated? || user.rejected?
  end
end
