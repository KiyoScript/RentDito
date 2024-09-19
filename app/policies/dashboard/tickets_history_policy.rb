class Dashboard::TicketsHistoryPolicy < ApplicationPolicy
  def index?
    user.verified?
  end

  def show?
    user.verified?
  end
end
