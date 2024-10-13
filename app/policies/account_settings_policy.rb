class AccountSettingsPolicy < ApplicationPolicy
  def show?
    user.landlord? || user.verified?
  end

  def update?
    user.landlord? || user.verified?
  end
end
