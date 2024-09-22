class Dashboard::TicketsHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: :show
  before_action :set_policy!


  def index
    @q = Ticket.ransack(params[:q])
    if current_user.tenant?
      @pagy, @tickets = pagy(@q.result.where(tenant: current_user.tenant).where(status: 'closed').order(created_at: :desc), distinct: true)
    elsif current_user.landlord?
      @pagy, @tickets = pagy(@q.result.where(status: 'closed').order(created_at: :desc), distinct: true)
    else
      @pagy, @tickets = pagy(@q.result.assigned_to_user(current_user).where(status: 'closed').order(created_at: :desc), distinct: true)
    end
  end

  def show;end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::TicketsHistoryPolicy
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end
