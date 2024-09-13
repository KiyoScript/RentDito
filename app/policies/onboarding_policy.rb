class OnboardingPolicy < ApplicationPolicy
  def show?
     user.unverified? || user.incomplete? || user.deactivated? || user.rejected?
  end
end
