class BalancesPolicy < ApplicationPolicy
  def index?
    (user.tenant? && user.verified?) || ( user.utility_staff? && user.verified?)
  end
end
