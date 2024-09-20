class Dashboard::TicketsController < ApplicationController
  include Dashboard::TicketsHelper
  before_action :authenticate_user!
  before_action :set_ticket, except: %i[index new create]
  before_action :set_staff_members, only: %i[show assign_staff]
  before_action :set_policy!, except: %i[assign_staff close_ticket]

  def index
    @q = Ticket.ransack(params[:q])
    if current_user.tenant?
      @pagy, @tickets = pagy(@q.result.where(tenant: current_user.tenant).where.not(status: 'closed').order(created_at: :asc), distinct: true)
    elsif current_user.landlord?
      @pagy, @tickets = pagy(@q.result.where.not(status: 'closed').order(created_at: :asc), distinct: true)
    else
      @pagy, @tickets = pagy(@q.result.assigned_to_user(current_user).where.not(status: 'closed').order(created_at: :asc), distinct: true)
    end
  end

  def show;end

  def new
    @ticket = current_user.tenant.tickets.new
  end


  def create
    @ticket = current_user.tenant.tickets.new(ticket_params)
    if @ticket.save
      redirect_to dashboard_tickets_path, notice: 'Successfully created'
    else
      redirect_to new_dashboard_ticket_path, alert: @ticket.errors.full_messages.first
    end
  end


  def assign_staff
    assigned_to = User.find(params[:ticket][:assigned_to_id])

    if @ticket.update(
      status: :pending,
      assigned_to_id: assigned_to.id,
      assigned_to_type: assigned_to.class.name
    )
      redirect_to dashboard_ticket_path(@ticket), notice: 'Staff assigned successfully.'
    else
      redirect_to dashboard_ticket_path(@ticket), alert: 'Failed to assign staff.'
    end
  end


  def close_ticket
    if @ticket.update(status: :closed)
      redirect_to dashboard_tickets_history_path(@ticket), notice: 'Ticket closed successfully.'
    else
      redirect_to dashboard_ticket_path(@ticket), alert: 'Failed to close ticket.'
    end
  end

  def destroy
    if @ticket.destroy
      redirect_to dashboard_tickets_path, notice: 'Successfully removed'
    else
      redirect_to dashboard_ticket_path(@ticket), alert: @ticket.errors.full_messages.first
    end
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::TicketsPolicy
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def set_staff_members
    @staff_members = User.staff_members
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :category, :label, :datetime, :status, images: [])
  end
end
