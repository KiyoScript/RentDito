class Dashboard::TicketsPolicy < ApplicationPolicy
  def index?
    user.verified?
  end

  def show?
    user.verified?
  end

  def new?
    user.verified? && user.tenant?
  end

  def create?
    user.verified? && user.tenant?
  end

  def destroy?
    user.verified? && user.tenant?
  end
end
