class Dashboard::TransactionsPolicy < ApplicationPolicy
  def index?
    user.landlord? || (user.admin? && user.verified?) || (user.tenant? && user.verified?)
  end
end
