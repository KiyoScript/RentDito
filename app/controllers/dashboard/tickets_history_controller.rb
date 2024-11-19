class Dashboard::TicketsHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: [:show, :review]
  before_action :set_policy!, except: :review

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

  def show; end

  def review
    if @ticket.update(review_params)
      redirect_to dashboard_tickets_history_path(@ticket), notice: "Your review has been submitted successfully."
    else
      redirect_to dashboard_tickets_history_path(@ticket), alert: "There was an issue submitting your review."
    end
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::TicketsHistoryPolicy
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def review_params
    params.require(:ticket).permit(:rating, :review)
  end
end
